inspect = (require('util')).inspect
url = require('url')
querystring = require('querystring')

module.exports = (robot) ->
  robot.router.post "/hubot/deploys", (req, res) ->
    query = querystring.parse(url.parse(req.url).query)
    room = query.room || process.env["HUBOT_GITHUB_EVENT_NOTIFIER_ROOM"]
    data = req.body

    robot.logger.debug "capistrano-deploys: Received POST to /hubot/deploys with data = #{inspect data}"

    if data.event_type == 'start'
      robot.messageRoom room, "#{data.user} started deploying #{data.sha} to #{data.stage}"
    else
      robot.messageRoom room, "#{data.user} finished deploying #{data.sha} to #{data.stage}"
      robot.messageRoom room, "#{data.stage} changed from #{data.previous_sha} to #{data.sha} [#{data.link}]"

    res.end ''
