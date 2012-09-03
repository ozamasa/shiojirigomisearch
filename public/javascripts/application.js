// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function submit(url, formname, method){
    var form = document.forms[0];
    if (formname != null) {
        form = document.forms[formname];
    }
    if (method == null || method == '') {
        method = 'POST'
    }
    form.action = url;
    form.method = method;
    form.submit();
}

function sort(col, order){
    var formname = 'form_search';
    var form = document.forms[formname];
    document.getElementById('sort' ).value=col;
    document.getElementById('order').value=order;
    submit('', formname, 'GET');
}

function pop(url, h, winName){
  if(h == undefined || h == null){
    h = 300;
  }
    var win = window.open( url, winName, 'width=700, height=' + h + ', menubar=no, toolbar=no, scrollbars=yes, resizable=yes' );
    win.focus();

}

function windowClose(){
  window.close();
}

function pageTop(targetID){
  if(targetID == undefined || targetID == null){
    targetID = 'header';
  }
  new Effect.ScrollTo(targetID, {fps:60, duration: 0.5});
}

function insertComma(str) {
  var num = new String( str ).replace( /,/g, "" );
  while ( num != ( num = num.replace( /^(-?\d+)(\d{3})/, "$1,$2" ) ) );
  return num;
}

function deleteComma(str){
  var num = new String( str ).replace( /,/g, "" ); return num;
}

function checkNum(val){
  flg = false;

  if(!isNull(val)){
    if(isNum(val)){
      flg = true;
    }
  }
  return flg;
}

function isNum(elm){
  flg = true;
  var reg = new RegExp(/[^0-9]/);
  if(elm.match(reg)){
    flg = false;
  }
  return flg;
}

function isNull(val){
  if(val == null || val == ''){
    return true;
  }
  return false;
}

/*** jQuery / prototype.js ***/

/* prototype.js/jQueryコンフリクト抑制 */
var $q = jQuery.noConflict(true);

function datePick() {
    $q('input:text[class="ymd"]').datepicker({
        showOn: 'both',
        buttonImage: '/images/calendar.gif',
        buttonImageOnly: true
    });
}

function colorRow() {
    $q('.commonList tbody tr:nth-child(even)').addClass('even');
}

$q(function() {
    datePick();
    colorRow();
});

function showMsg(box, btn){
  var item = $(box);
  Effect.toggle(item, 'appear', {duration: 0.17});

  if ($(btn).hasClassName("msgMinus")) {
    $(btn).removeClassName("msgMinus");
    $(btn).addClassName("msgPlus");
    return 1
  }
  else {
    $(btn).removeClassName("msgPlus");
    $(btn).addClassName("msgMinus");
    return 0
  }
}

function ref(url){
  location.href = url;
}

function showCalClearBtn(obj) {
  var calObj = $(obj).previous('input.ymd');
  $(calObj).clear();
}

