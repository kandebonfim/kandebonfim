class Impeachmap
  constructor: ->
    @votes = impeachmapData
    @votesContainer = document.querySelectorAll(".js-impeachmap-votes")[0]
    @printAllData()
    waitForIt 300, => @bindClickEvents()

  addActiveStateClass: (state) ->
    active = document.querySelectorAll(".impeachmap__state[is-active]")[0]
    if active
      active.removeAttribute('is-active')

    document.querySelectorAll(".impeachmap__state[state='#{state}']")[0].setAttribute('is-active', true)

  printStateData: (state) ->
    @printStateInfo state.getAttribute('state-full'), state.getAttribute('region')
    votes = @findVotesByState state.getAttribute('state')
    @printRelativeVotes @findVoteMetrics votes, 'relative'
    @printAbsoluteVotes @findVoteMetrics votes
    @addActiveStateClass state.getAttribute('state')

  printAllData: ->
    @printStateInfo 'Votação Geral', 'Todos os estados'
    @printRelativeVotes @findVoteMetrics @votes, 'relative'
    @printAbsoluteVotes @findVoteMetrics @votes

  printStateInfo: (state, region) ->
    @votesContainer.innerHTML = ''
    document.querySelectorAll('.js-impeachmap-state-name')[0].innerHTML = state
    document.querySelectorAll('.js-impeachmap-region')[0].innerHTML = region

  printRelativeVotes: (data) ->
    bars = document.querySelectorAll('.js-impeachmap-bars')
    for key, i in data
      bars[i].style.width = "#{key}%"

  printAbsoluteVotes: (data) ->
    labels = document.querySelectorAll('.js-impeachmap-labels')
    for key, i in data
      labels[i].innerHTML = key

  findVoteMetrics: (data, response = 'absolute') ->
    gauge =
      neg: 0
      ind: 0
      pos: 0

    for vote in data
      switch @readVote vote.Posicao
        when true
          @printVote(vote, 'pos')
          gauge.pos = gauge.pos + 1
        when false
          @printVote(vote, 'neg')
          gauge.neg = gauge.neg + 1
        when null
          @printVote(vote, 'ind')
          gauge.ind = gauge.ind + 1

    if response == 'relative'
      [1, gauge.ind/data.length + gauge.pos/data.length, gauge.pos/data.length].map (i) -> i*100
    else
      [gauge.neg, gauge.ind, gauge.pos]

  readVote: (voteString) ->
    switch voteString
      when 'A favor'
        true
      when 'Contra'
        false
      when 'Não opinou'
        null

  printVote: (vote, container) ->
    template = "
      <div class='impeachmap__vote'>
        <div class='impeachmap__candidate'>#{vote.Nome}</div>
        <div class='impeachmap__party'>#{vote.Partido}</div>
      </div>"

    unless document.querySelectorAll(".js-impeachmap-votes-#{container}")[0]
      container = "<div class='js-impeachmap-votes-#{container}'></div>"
      @votesContainer.innerHTML = @votesContainer.innerHTML + container
    else
      container = document.querySelectorAll(".js-impeachmap-votes-#{container}")[0]

    container.innerHTML = container.innerHTML + template

  findVotesByState: (state) ->
    result = []
    for vote in @votes
      if vote.UF == state
        result.push(vote)
    result

  bindClickEvents: ->
    classname = document.querySelectorAll('.impeachmap__state')

    trigger = =>
      @printStateData(event.target)

    i = 0
    while i < classname.length
      classname[i].addEventListener 'click', trigger, false
      i++

# Helpers
waitForIt = (ms, func) => setTimeout func, ms

container = document.querySelectorAll('.js-impeachmap')[0]
if container
  impeachmap = new Impeachmap
