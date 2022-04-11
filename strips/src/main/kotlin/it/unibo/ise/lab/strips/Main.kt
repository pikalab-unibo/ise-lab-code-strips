package it.unibo.ise.lab.strips

import it.unibo.tuprolog.core.Integer
import it.unibo.tuprolog.core.Struct
import it.unibo.tuprolog.core.operators.OperatorSet
import it.unibo.tuprolog.core.parsing.TermParser
import it.unibo.tuprolog.solve.*
import it.unibo.tuprolog.solve.channel.OutputChannel
import it.unibo.tuprolog.solve.exception.Warning
import it.unibo.tuprolog.theory.Theory
import it.unibo.tuprolog.theory.parsing.ClausesReader
import java.net.URL

object Main {
    private var verbose = false

    private var initialState: String? = null
    private var goal: String? = null
    private var worldFile: String? = null
    private var maxDepth: String? = "10"

    @JvmStatic
    fun main(args: Array<String>) {
        verbose = hasFlag(args, "-v", "--verbose")
        initialState = getArg(args, initialState, "-is", "--initialState")
        goal = getArg(args, goal, "-g", "--goal")
        worldFile = getArg(args, worldFile, "-w", "--world")
        maxDepth = getArg(args, maxDepth, "-md", "--maxDepth")

        var theory = parseFileAsTheory(Main::class.java.getResource("/$worldFile.pl"))
        theory = theory.plus(parseFileAsTheory(Main::class.java.getResource("/Strips.pl")))
        theory = theory.plus(parseFileAsTheory(Main::class.java.getResource("/Utils.pl")))

        val agent = createEngineWithTheory(theory)

        agent.assertA(Struct.of("max_depth", Integer.of(maxDepth!!)))

        while (true) {
            val line = if (initialState == null) {
                print("?- ")
                readLine()
            } else {
                val query = "strips($initialState, $goal, Plan).";
                println("?- $query")
                query
            }
            if (line == null) break

            val goal = TermParser.withOperators(agent.operators).parseStruct(line)
            agent.solve(goal).forEach {
                printSolution(agent.operators, it)
                readLine()
            }
        }
    }

    private fun printSolution(operators: OperatorSet, current: Solution) {
        println(SolutionFormatter.withOperators(operators).format(current))
    }

    private fun parseFileAsTheory(file: URL?): Theory {
        file!!.openStream().use { return ClausesReader.withDefaultOperators.readTheory(it) }
    }

    private fun createEngineWithTheory(theory: Theory): MutableSolver {
        return Solver.prolog.mutableSolverWithDefaultBuiltins(
            staticKb = theory,
            stdOut = OutputChannel.of(this::printOutput),
            stdErr = OutputChannel.of(this::printError),
            warnings = OutputChannel.of(this::printWarning)
        )
    }

    private fun printOutput(message: String) {
        if (verbose) {
            print(message)
        }
    }

    private fun printError(message: String) {
        if (verbose) {
            System.err.print(message)
        }
    }

    private fun printWarning(`object`: Warning) {
        System.err.println(`object`.message)
    }

    private fun hasFlag(args: Array<String>, vararg flags: String): Boolean =
        sequenceOf(*args).any { it in flags }

    private fun getArg(args: Array<String>, defaultArg: String?, vararg keys: String): String? =
        sequenceOf(*args)
            .mapIndexed(::Pair)
            .filter { (_, it) -> it in keys }
            .map { (i, _) -> args[i + 1] }
            .firstOrNull()
            ?: defaultArg
}