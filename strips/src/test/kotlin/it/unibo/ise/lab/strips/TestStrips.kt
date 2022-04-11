package it.unibo.ise.lab.strips

import it.unibo.tuprolog.core.parsing.parseAsClause
import it.unibo.tuprolog.core.parsing.parseAsStruct
import it.unibo.tuprolog.solve.Solution
import it.unibo.tuprolog.solve.SolutionFormatter
import it.unibo.tuprolog.solve.Solver
import it.unibo.tuprolog.solve.channel.OutputChannel
import it.unibo.tuprolog.theory.Theory
import kotlin.test.Test
import kotlin.test.assertIs

class TestStrips {

    private fun prologPlanner(world: String, maxDepth: Int): Solver =
        Solver.prolog.solverWithDefaultBuiltins(
            staticKb = World.load(world),
            dynamicKb = Theory.of("max_depth($maxDepth)".parseAsClause()),
            stdOut = OutputChannel.of { print(it) },
            stdErr = OutputChannel.of { /* do nothing */ },
            warnings = OutputChannel.of { throw it }
        )

    private fun testInWorld(world: String, maxDepth: Int = 5, theory: () -> String) {
        val solver = prologPlanner(world, maxDepth)
        val solution = solver.solveOnce(theory().parseAsStruct())

        assertIs<Solution.Yes>(solution)
        println(SolutionFormatter.withOperators(solver.operators).format(solution))
    }

    @Test
    fun testBlockWorld() {
        testInWorld("BlockWorld") {
            """
            strips(
                [on(a, c), ontable(b), ontable(c), clear(a), clear(b), handempty],
                [on(c, b), on(b, a), clear(c)],
                Plan
            )
            """
        }
    }

    @Test
    fun testRegisters() {
        testInWorld("Registers") {
            """
            strips(
                [register(eax, 0)],
                [register(eax, -2)],
                Plan
            )
            """
        }
    }

    @Test
    fun testStack() {
        testInWorld("Stack", maxDepth = 7) {
            """
            strips(
                [on(2, on(1, bottom))],
                [on(-1, _)],
                Plan
            )
            """
        }
    }
}