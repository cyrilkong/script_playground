// Generated by CoffeeScript 1.3.3
(function() {

  $(document).ready(function(dom) {
    var deviceAgent, docBody, external_link_Fx, isFirefox, isIE, isIE7, isIE8, isMobile, isSafari, isWebkit, placeholder_init, styled_select_Fx;
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
    $.fn.placeholder = function(o) {
      var defaults, options, testinput;
      defaults = {
        placeholderClass: 'placeholder'
      };
      options = $.extend(defaults, o);
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
              color: '#6D6D6D',
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
          }).insertAfter(this);
          $(this).val('').addClass(options.placeholderClass);
          pw_holder.click(function() {
            pw_holder.hide();
            $(this).prev('input[type="password"]').focus().addClass('typing').removeClass(options.placeholderClass);
          });
          $(this).focusin(function() {
            if ($(this).hasClass(options.placeholderClass)) {
              pw_holder.hide();
              $(this).removeClass(options.placeholderClass);
            }
          });
          $(this).focusout(function() {
            if ($(this).val() === '') {
              pw_holder.show();
              $(this).val('').addClass(options.placeholderClass);
            }
          });
        }
        if ($(this).attr('type') !== 'password') {
          placeholder_val = $(this).attr('placeholder');
          $(this).css({
            color: '#6D6D6D',
            fontFamily: '"Segoe UI", sans-serif',
            fontSize: $(this).css('font-size')
          });
          $(this).focusin(function() {
            $(this).css('color', '#000');
            $(this).removeClass(options.placeholderClass);
            if ($(this).val() === placeholder_val) {
              $(this).val('').removeClass(options.placeholderClass);
            }
          });
          $(this).focusout(function() {
            if ($(this).val() === placeholder_val) {
              $(this).css('color', '#6D6D6D');
              $(this).addClass(options.placeholderClass);
            } else if ($(this).val() === '') {
              $(this).val(placeholder_val).removeClass(options.placeholderClass);
              $(this).css('color', '#6D6D6D');
            } else {
              $(this).css('color', '#000');
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
        var $input;
        $input = $(this);
        $input.focusin(function() {
          $(this).addClass('typing');
        });
        return $input.focusout(function() {
          $(this).removeClass('typing');
        });
      }).placeholder();
    })();
    external_link_Fx = (function() {
      $('a[rel="external"]').each(function() {
        $(this).attr('target', '_blank');
      });
    })();
    styled_select_Fx = (function() {
      if (!dom.find('select').length) {
        return false;
      }
      $('select.styled').each(function() {
        var h, ma, ol, ot, select_title, w;
        select_title = $(this).attr('title');
        ma = $(this).css('margin') !== 'undefined' ? $(this).css('margin') : 0;
        $(this).css({
          border: '1px solid transparent',
          margin: ma
        });
        ot = isWebkit ? $(this).offset().top - 2 : $(this).offset().top;
        ol = isWebkit ? $(this).offset().left - 2 : $(this).offset().left;
        if ($('option:selected', this).val() !== '') {
          select_title = $('option:selected', this).text();
          $(this).width($(this).width() + 20);
        }
        h = $(this).height();
        w = $(this).width();
        $(this).css({
          position: 'relative',
          'z-index': 10,
          opacity: 0,
          '-khtml-apperance': 'none'
        }).after('<span class="select fakeSelect">' + select_title + '</span>').change(function() {
          var select_css, val;
          select_css = $('option:selected', this).attr('class');
          val = $('option:selected', this).text();
          $(this).siblings('span.select').html(val);
          if (select_css) {
            $(this).siblings('span.select').html(val);
          } else if (!select_css || select_css === 'undefined') {
            $(this).siblings('span.select').removeClass('submitted');
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
      });
    })();
  });

}).call(this);