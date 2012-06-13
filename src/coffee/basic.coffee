console.log """
jQuery is loaded, global variable are
isFirefox, isSafari, isWebkit, docBody, isIE, isIE7, isIE8, isMobile
"""

# device/browser detection
isFirefox = $.browser.mozilla
isSafari = $.browser.safari
isWebkit = $.browser.webkit
docBody = if isWebkit then 'body' else 'html'
isIE = $.browser.msie
isIE7 = $.browser.msie and $.browser.version is 7.0
isIE8 = $.browser.msie and $.browser.version is 8.0
deviceAgent = navigator.userAgent.toLowerCase()
isMobile = deviceAgent.match /(iphone|ipod|ipad|android)/ isnt null

# dom ready()
$(document).ready (dom) ->

    # eqHeight()
    $.fn.eqHeight = (minH, maxH) ->
        tallest = if minH then maxH else 0
        @.each ->
            tallest = $(@).height() if $(@).height() > tallest
        tallest = maxH if maxH and tallest > maxH
        @.each ->
            $(@).height(maxH).css 'overflow', 'auto'
            return
        return
    # eqHeight() end

    # placeholder(class, color, typing)
    $.fn.placeholder = (op) ->
        defaults = 
            placeholderClass : 'placeholder'
            placeholderColor : '#898989'
            typingColor : '#222'
        
        options = $.extend(defaults, op)

        if op isnt undefined
            options.placeholderClass = op.placeholderClass or options.placeholderClass
            options.placeholderColor = op.placeholderColor or options.placeholderColor
            options.typingColor = op.typingColor or options.typingColor
        
        # check placeholder
        testinput = document.createElement('input')
        $.extend $.support,
            placeholder : 'placeholder' of testinput
        # stop it if can native support placeholder
        if $.support.placeholder
            $('input[placeholder]').css
                fontFamily: '"Segoe UI", sans-serif'
            return false
        $(@).each ->
            should_value = $(@).attr 'placeholder'
            cur_value = $(@).val()
            $(@).attr 'autocomplete', 'off'

            if cur_value is ''
                $(@).addClass options.placeholderClass
                $(@).val should_value

            # placeholder for input type password
            if $(@).attr('type') is 'password'
                placeholder_val = $(@).attr 'placeholder'
                pw_holder = $('<span />',
                    text: placeholder_val,
                    'class': 'pw_' + options.placeholderClass,
                    css:
                        fontSize: $(@).css 'font-size'
                        position: 'absolute'
                        fontFamily: '"Segoe UI", sans-serif'
                        background: 'transparent'
                        cursor: 'text'
                        border: '0'
                        top: $(@).position().top
                        left: $(@).position().left
                        lineHeight: parseFloat($(@).height()) + 'px'
                        height: parseFloat($(@).height()) + 'px'
                        margin: '2px'
                        padding: '1px'
                        paddingLeft: $(@).css('padding-left') + 2 + 'px'
                )

                if not $(@).next('span.pw_' + options.placeholderClass).length
                    $(@).after(pw_holder)

                $(@).next('span.pw_' + options.placeholderClass).css
                    color: options.placeholderColor

                $(@).val('').addClass options.placeholderClass

                # placeholder password holder
                pw_holder.on
                    click: ->
                        $(@).prev('input[type="password"]').focus().addClass('typing').removeClass options.placeholderClass
                        return
                $(@).on
                    focusin: ->
                        if $(@).hasClass options.placeholderClass
                            pw_holder.hide()
                            $(@).removeClass options.placeholderClass
                        return
                    focusout: ->
                        if $(@).val() is ''
                            pw_holder.show()
                            $(@).val('').addClass options.placeholderClass
                        return

            # placeholder for input type text
            if $(@).attr('type') isnt 'password'
                placeholder_val = $(@).attr 'placeholder'
                $(@).css 
                    color: options.placeholderColor
                    fontFamily: '"Segoe UI", sans-serif'
                    fontSize: $(@).css 'font-size'
                
                $(@).on
                    focusin: ->
                        $(@).css 'color', options.typingColor
                        $(@).removeClass options.placeholderClass
                        $(@).val('').removeClass options.placeholderClass if $(@).val() is placeholder_val
                        return
                    focusout: ->
                        if $(@).val() is placeholder_val
                            $(@).css 'color', options.placeholderColor
                            $(@).addClass options.placeholderClass
                        else if $(@).val() is ''
                            $(@).val(placeholder_val).removeClass options.placeholderClass
                            $(@).css 'color', options.placeholderColor
                        else
                            $(@).css 'color', options.typingColor 
                        return

            # placeholder for input end, form submit handler
            $(@).parents('form').submit ->
                $(@).find('[placeholder]').each ->
                    input = $(@)
                    input.val('') if input.val() is input.attr 'placeholder'
                    return
                return
            return
        return
    # placeholder() end

    # placeholder_init()
    placeholder_init = do ->
        return false if not dom.find('input').length
        
        $('input.placeholder, input[placeholder]').each ->
            $(@).on
                focusin: ->
                    $(@).addClass 'typing'
                    return
                focusout: ->
                    $(@).removeClass 'typing'
                    return
            .placeholder()
            return
        return
    # placeholder_init() end

    # external_link_Fx()
    external_link_Fx = do ->
        $('a[rel="external"]').each ->
            $(@).attr 'target', '_blank'
            return
        return
    # external_link_Fx() end
    
    # styled_select_Fx()
    styled_select_Fx = do ->
        # stop if dom is no select
        $select = $('select.styled')
        return false if not dom.find('select').length
        # action styling
        $.fn.do_ele_style = ->
            
            select_title = $(@).attr 'title'
            ma = if $(@).css('margin') isnt undefined then $(@).css('margin') else 0
            $(@).css
                border: '1px solid transparent'
                margin: ma
            ot = if isWebkit then $(@).position().top else $(@).position().top
            ol = if isWebkit then $(@).position().left else $(@).position().left
            if $('option:selected', @).val() isnt ''
                select_title = $('option:selected', @).text()
                if isIE8 then $(@).width 'auto' else $(@).width $(@).width() + 20
            h = $(@).height()
            w = $(@).width()
            $(@).css
                position: 'relative'
                'z-index': 10
                opacity: 0
                '-khtml-apperance': 'none'
            .after('<span class="select fakeSelect">' + select_title + '</span>')
            .change ->
                select_css = $('option:selected', @).attr 'class'
                val = $('option:selected', @).text()
                fakeSelect = $(@).next('span.select')
                fakeSelect.text val
                if select_css is 'submitted'
                    fakeSelect.addClass 'submitted'
                else
                    fakeSelect.removeClass 'submitted'
                $(@).attr('title',val)
                return
            .next('span.select').css
                position: 'absolute'
                border: '1px solid transparent'
                left: ol
                top: ot
                height: h+'px'
                width: w+'px'
                lineHeight: h+'px'
                display: 'block'
                margin: ma
            selected_check = $('option:selected', @).attr 'class'
            fakeSelect = $(@).next('span.select')
            if selected_check is 'submitted' and fakeSelect.length
                fakeSelect.addClass 'submitted'
            else if selected_check isnt 'submitted' and fakeSelect.length
                fakeSelect.removeClass 'submitted'
            return
        # check if element no height
        check_ele_first = do ->
            $select.each ->
                flag = false
                if $(@).is ':visible'
                    flag = true
                $(@).do_ele_style() if flag
                return 
            return
        return
    # styled_select_Fx() end
    
    return
    # dom functions end
# coffee script end



