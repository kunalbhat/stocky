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
    tyoe: 'POST',
    url: '/stocks',
    data: { symbol: symbol },
    dataType: 'json',
    success: callback
  })

$stockList = $('.stock-list')
$($stockList[0]).addClass('active')

$($('.nav-item')[0]).addClass('active')

$('.nav-item').click (e) ->
  e.preventDefault()
  index = $(@).index()

  $('.nav-item').removeClass('active')
  $(@).addClass('active')

  $('.stock-list').removeClass('active')
  $($('.stock-list')[index]).addClass('active')

$('#symbol-lookup').click ->
  $('.symbol-lookup-wrapper').toggleClass('visible')

$('#add-symbol').click ->
  $('.add-symbol-wrapper').toggleClass('visible')

window.bindEvents =  ->

  $(document).on 'click', '.remove', (e) ->
    e.preventDefault()
    stock = $(e.currentTarget).attr('name')
    window.stocks = _.reject(window.stocks, (symbol) -> symbol is stock)
    localStorage.setItem('stocks', window.stocks)
    $('li[name=' + stock + ']').remove()

  $('.stock-list li').click ->
    $(this).toggleClass('show-drawer')

  $('#add-symbol-form').submit (event) ->
    event.preventDefault()
    symbol = $(this).find('input')[0].value

    unless _.include(window.stocks, symbol)
      window.stocks.push(symbol)
      localStorage.setItem('stocks', window.stocks)

      stock = {symbol: symbol, last_price: ''}

      $('.stock-list').append('<li name="' + stock.symbol + '">' + template(stock) + '</li>')

      callback = (data) ->
        $($('li[name=' + symbol + ']')[0]).html(template(data))
        $('.stock-list').append()
        $('#add-symbol-form input').val('')

      $.ajax({
        contentType: 'application/json',
        url: '/stocks',
        data: { symbol: symbol },
        dataType: 'json',
        success: callback
      })

      window.bindEvents()

$(-> window.bindEvents())
