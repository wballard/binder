env = jasmine.getEnv()
env.updateInterval = 1000;

reporter = new jasmine.HtmlReporter()

env.addReporter reporter

env.specFilter = (spec) ->
    reporter.specFilter spec

env.execute()
