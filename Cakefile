{print} = (require 'util')
{spawn} = (require 'child_process')

task 'watch', 'Watch js and css', ->
    workers = [
        spawn('node', ['node_modules/coffee-script/bin/coffee', '-w', '-j','js/app/app.js', '-c', 'js/app/'])
        , spawn('node', ['node_modules/stylus/bin/stylus', '-w', '-o', 'css/', 'css/'])
    ]
    for worker in workers
        worker.stderr.on 'data', (data) -> process.stderr.write data.toString()
        worker.stdout.on 'data', (data) -> print data.toString()
