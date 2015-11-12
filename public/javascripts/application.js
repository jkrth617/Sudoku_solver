$(document).on('ready', function () {
  $('#solve').on('click', function (e) {
    var myData = $('form').serialize();
    var boardString = getValue(myData);
    var sudokuGame = new Sudoku(boardString);
    var answerArray = sudokuGame.solveGame();
    if (answerArray) {
      $('#error').hide();
      fillInBoard(answerArray);
    }else {
      $('#error').show();
    }
  })

  $('#clear').on('click', clearForm)
})

var validInputs = _.map(_.range(1, 10), function (num) {return num+""} )

var getValue = function (bigString) {
  var valueArray = bigString.split("&");
  valueArray = _.map(valueArray, function (input) {
    var breakIndex = input.indexOf("=");
    var cell = input.substring(breakIndex+1);
    if (cell === "" || !_.contains(validInputs, cell)) {cell = "-";}
   return cell;
  })
  return valueArray.join("")
};

var fillInBoard = function (answer) {
  for(var i = 0; i < answer.length; i++){
    $('#cell'+ answer[i].index).val(answer[i].value);
  }
};

var clearForm = function () {
  for(var i = 0; i < 81; i++){
    $('#cell'+i).val("");
  }
};

