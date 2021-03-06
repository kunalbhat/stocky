if savedData = localStorage.getItem('stocks')
  window.stocks = savedData.split(',')
else
  window.stocks = ['GOOG', 'AAPL', 'YHOO']

source   = $("#stock-template").html()
template = Handlebars.compile(source)

_.each window.stocks, (symbol) ->
  stock = {symbol: symbol, last_price: ''}

  $('.stock-list').append('<li name="' + stock.symbol + '">' + template(stock) + '</li>')

  callback = (data) ->
    $($('li[name=' + symbol + ']')[0]).html(template(data))
    window.bindEvents()

  $.ajax({
    contentType: 'application/json',
    type: 'GET',
    url: '/stocks',
    data: { symbol: symbol },
    dataType: 'json',
    success: callback
  })

$('#symbol-lookup').click ->
  $('.add-symbol-wrapper').removeClass('visible')
  $('.symbol-lookup-wrapper').toggleClass('visible')

$('#add-symbol').click ->
  $('.symbol-lookup-wrapper').removeClass('visible')
  $('.add-symbol-wrapper').toggleClass('visible')

$('.stock-list li').click ->
  $(@).toggleClass('show-drawer')

window.bindEvents =  ->

  $(document).on 'click', '.remove', (event) ->
    event.preventDefault()

    stock = $(event.currentTarget).attr('name')

    removeSymbol(stock)

  removeSymbol = (symbol) ->
    stock = symbol

    window.stocks = _.reject(window.stocks, (symbol) -> symbol is stock)
    localStorage.setItem('stocks', window.stocks)
    $('li[name=' + stock + ']').remove()

  $('#add-symbol-form').submit (event) ->
    event.preventDefault()

    symbol = $(this).find('input')[0].value

    unless _.include(window.stocks, symbol)
      window.stocks.push(symbol)
      localStorage.setItem('stocks', window.stocks)

      stock = {symbol: symbol, last_price: ''}

      $('.stock-list').append("<li name='" + stock.symbol + "'>" + template(stock) + "</li>")

      callback = (data) ->
        $($('li[name=' + symbol + ']')[0]).html(template(data))
        $('.stock-list').append()
        $('#add-symbol-form input').val('')

      failure = (data) ->
        alert "This symbol does not exist"
        removeSymbol(symbol)

      $.ajax({
        contentType: 'application/json',
        type: 'GET',
        url: '/stocks',
        data: { symbol: symbol },
        dataType: 'json',
        success: callback,
        error: failure
      })

      window.bindEvents()

$(-> window.bindEvents())
