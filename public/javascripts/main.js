// compiled mainjs VERSION 2.0, author is Cyril Kong
// powered by cake + coffee.
var deviceAgent, docBody, dom, external_link_Fx, isFirefox, isIE, isIE7, isIE8, isMobile, isSafari, isWebkit, placeholder_init, styled_select_Fx;

console.log("jQuery is loaded, global variable are\nisFirefox, isSafari, isWebkit, docBody, isIE, isIE7, isIE8, isMobile");

dom = jQuery(document);

isFirefox = $.browser.mozilla;

isSafari = $.browser.safari;

isWebkit = $.browser.webkit;

docBody = isWebkit ? 'body' : 'html';

isIE = $.browser.msie;

isIE7 = $.browser.msie && $.browser.version === 7.0;

isIE8 = $.browser.msie && $.browser.version === 8.0;

deviceAgent = navigator.userAgent.toLowerCase();

isMobile = deviceAgent.match(/(iphone|ipod|ipad|android)/ !== null);

$.fn.eqHeight = function(minH, maxH) {
  var tallest;
  tallest = minH ? maxH : 0;
  this.each(function() {
    if ($(this).height() > tallest) {
      return tallest = $(this).height();
    }
  });
  if (maxH && tallest > maxH) {
    tallest = maxH;
  }
  this.each(function() {
    $(this).height(maxH).css('overflow', 'auto');
  });
};

$.fn.placeholder = function(op) {
  var defaults, options, testinput;
  defaults = {
    placeholderClass: 'placeholder',
    placeholderColor: '#898989',
    typingColor: '#222'
  };
  options = $.extend(defaults, op);
  if (op !== void 0) {
    options.placeholderClass = op.placeholderClass || options.placeholderClass;
    options.placeholderColor = op.placeholderColor || options.placeholderColor;
    options.typingColor = op.typingColor || options.typingColor;
  }
  testinput = document.createElement('input');
  $.extend($.support, {
    placeholder: 'placeholder' in testinput
  });
  if ($.support.placeholder) {
    $('input[placeholder]').css({
      fontFamily: '"Segoe UI", sans-serif'
    });
    return false;
  }
  $(this).each(function() {
    var cur_value, placeholder_val, pw_holder, should_value;
    should_value = $(this).attr('placeholder');
    cur_value = $(this).val();
    $(this).attr('autocomplete', 'off');
    if (cur_value === '') {
      $(this).addClass(options.placeholderClass);
      $(this).val(should_value);
    }
    if ($(this).attr('type') === 'password') {
      placeholder_val = $(this).attr('placeholder');
      pw_holder = $('<span />', {
        text: placeholder_val,
        'class': 'pw_' + options.placeholderClass,
        css: {
          fontSize: $(this).css('font-size'),
          position: 'absolute',
          fontFamily: '"Segoe UI", sans-serif',
          background: 'transparent',
          cursor: 'text',
          border: '0',
          top: $(this).position().top,
          left: $(this).position().left,
          lineHeight: parseFloat($(this).height()) + 'px',
          height: parseFloat($(this).height()) + 'px',
          margin: '2px',
          padding: '1px',
          paddingLeft: $(this).css('padding-left') + 2 + 'px'
        }
      });
      if (!$(this).next('span.pw_' + options.placeholderClass).length) {
        $(this).after(pw_holder);
      }
      $(this).next('span.pw_' + options.placeholderClass).css({
        color: options.placeholderColor
      });
      $(this).val('').addClass(options.placeholderClass);
      pw_holder.on({
        click: function() {
          $(this).prev('input[type="password"]').focus().addClass('typing').removeClass(options.placeholderClass);
        }
      });
      $(this).on({
        focusin: function() {
          if ($(this).hasClass(options.placeholderClass)) {
            pw_holder.hide();
            $(this).removeClass(options.placeholderClass);
          }
        },
        focusout: function() {
          if ($(this).val() === '') {
            pw_holder.show();
            $(this).val('').addClass(options.placeholderClass);
          }
        }
      });
    }
    if ($(this).attr('type') !== 'password') {
      placeholder_val = $(this).attr('placeholder');
      $(this).css({
        color: options.placeholderColor,
        fontFamily: '"Segoe UI", sans-serif',
        fontSize: $(this).css('font-size')
      });
      $(this).on({
        focusin: function() {
          $(this).css('color', options.typingColor);
          $(this).removeClass(options.placeholderClass);
          if ($(this).val() === placeholder_val) {
            $(this).val('').removeClass(options.placeholderClass);
          }
        },
        focusout: function() {
          if ($(this).val() === placeholder_val) {
            $(this).css('color', options.placeholderColor);
            $(this).addClass(options.placeholderClass);
          } else if ($(this).val() === '') {
            $(this).val(placeholder_val).removeClass(options.placeholderClass);
            $(this).css('color', options.placeholderColor);
          } else {
            $(this).css('color', options.typingColor);
          }
        }
      });
    }
    $(this).parents('form').submit(function() {
      $(this).find('[placeholder]').each(function() {
        var input;
        input = $(this);
        if (input.val() === input.attr('placeholder')) {
          input.val('');
        }
      });
    });
  });
};

placeholder_init = (function() {
  if (!dom.find('input').length) {
    return false;
  }
  $('input.placeholder, input[placeholder]').each(function() {
    $(this).on({
      focusin: function() {
        $(this).addClass('typing');
      },
      focusout: function() {
        $(this).removeClass('typing');
      }
    }).placeholder();
  });
})();

external_link_Fx = (function() {
  $('a[rel="external"]').each(function() {
    $(this).attr('target', '_blank');
  });
})();

styled_select_Fx = (function() {
  var $select, check_ele_first;
  $select = $('select.styled');
  if (!dom.find('select').length) {
    return false;
  }
  $.fn.do_ele_style = function() {
    var fakeSelect, h, ma, ol, ot, select_title, selected_check, w;
    select_title = $(this).attr('title');
    ma = $(this).css('margin') !== void 0 ? $(this).css('margin') : 0;
    $(this).css({
      border: '1px solid transparent',
      margin: ma
    });
    ot = isWebkit ? $(this).position().top : $(this).position().top;
    ol = isWebkit ? $(this).position().left : $(this).position().left;
    if ($('option:selected', this).val() !== '') {
      select_title = $('option:selected', this).text();
      if (isIE8) {
        $(this).width('auto');
      } else {
        $(this).width($(this).width() + 20);
      }
    }
    h = $(this).height();
    if ($(this).is(':visible')) {
      w = $(this).width();
    }
    $(this).css({
      position: 'relative',
      'z-index': 10,
      opacity: 0,
      '-khtml-apperance': 'none'
    }).after('<span class="select fakeSelect">' + select_title + '</span>').change(function() {
      var fakeSelect, select_css, val;
      select_css = $('option:selected', this).attr('class');
      val = $('option:selected', this).text();
      fakeSelect = $(this).next('span.select');
      fakeSelect.text(val);
      if (select_css === 'submitted') {
        fakeSelect.addClass('submitted');
      } else {
        fakeSelect.removeClass('submitted');
      }
      $(this).attr('title', val);
    }).next('span.select').css({
      position: 'absolute',
      border: '1px solid transparent',
      left: ol,
      top: ot,
      height: h + 'px',
      width: w + 'px',
      lineHeight: h + 'px',
      display: 'block',
      margin: ma
    });
    selected_check = $('option:selected', this).attr('class');
    fakeSelect = $(this).next('span.select');
    if (selected_check === 'submitted' && fakeSelect.length) {
      fakeSelect.addClass('submitted');
    } else if (selected_check !== 'submitted' && fakeSelect.length) {
      fakeSelect.removeClass('submitted');
    }
  };
  check_ele_first = (function() {
    $select.each(function() {
      var flag;
      flag = false;
      if ($(this).is(':visible')) {
        flag = true;
      }
      if (flag) {
        $(this).do_ele_style();
      }
    });
  })();
})();

$.fn.stickyfloat = function(options) {
  var $obj, initFloat, opts, parentPaddingTop, startOffset;
  $obj = $(this);
  parentPaddingTop = parseInt($obj.parent().css('padding-top'));
  startOffset = $obj.parent().offset().top;
  opts = $.fn.stickyfloat.opts;
  $.extend(opts, {
    startOffset: startOffset,
    offsetY: parentPaddingTop
  }, options);
  $obj.css({
    position: 'absolute'
  }).addClass('sticky');
  initFloat = function() {
    var bottomPos, newPos, objBiggerThanWindow, objFartherThanTopPos, pastStartOffset;
    $obj.stop();
    bottomPos = $obj.parent().height() - $obj.outerHeight() + parentPaddingTop;
    bottomPos = bottomPos < 0 ? 0 : bottomPos;
    pastStartOffset = dom.scrollTop() > opts.startOffset;
    objFartherThanTopPos = $obj.offset().top > startOffset;
    objBiggerThanWindow = $obj.outerHeight() < $(window).height();
    if ((pastStartOffset || objFartherThanTopPos) && objBiggerThanWindow) {
      newPos = opts.stickToBottom ? dom.scrollTop() + $(window.top).height() - $obj.outerHeight() - startOffset - opts.offsetY : dom.scrollTop() - startOffset + opts.offsetY;
      if (newPos > bottomPos) {
        newPos = bottomPos;
      } else if (dom.scrollTop() < opts.startOffset && !opts.stickToBottom) {
        newPos = parentPaddingTop;
      }
      if (opts.duration > 5) {
        $obj.stop().delay(opts.delay).animate({
          top: newPos
        }, opts.duration, opts.easing);
      } else {
        $obj.stop().css('top', newPos);
      }
    }
  };
  $(window).bind('scroll.sticky', initFloat);
};

$.fn.stickyfloat.opts = {
  duration: 200,
  lockBottom: true,
  delay: 0,
  easing: 'linear',
  stickToBottom: false
};

$(document).ready(function(dom) {
  $('#floating').stickyfloat();
});
