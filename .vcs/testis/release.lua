-- Testis configuration file v1.0.0
-- Observation available in internal platform
-- License: OOSLv1
-- Docs: vcs/testis/ci

-- Trigger events
triggered({
    push = {
        "main",
        "release/*"
    }
})

-- Installing external plugins
install("omnia:vincula")
install("omnia:platform")
install("omnia:release")
install("omnia:git")

-- The steps for building

-- Setup Job: Clone, spin-up vincula
job(
    "setup",
    function(context)
        context.plugins.git.clone(context.repository.url, context.branch.name)
        context.plugins.vincula.load_workspace()
    end,
    {}
)

-- Test Job: unittesting, valgrind
job(
    "run-tests",
    function(context)
        context.plugins.vincula.execute_command("test ...", { ignore_fail = true })
        context.plugins.platform.mem_check()
        context.platform.upload_report({})
    end,
    { depends_on = { "setup" } }
)

-- TODO(assertionbit): When release process will be stable, update following pipeline
