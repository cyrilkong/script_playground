# dom ready()
$(document).ready (dom) ->
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

	# placeholder()
	$.fn.placeholder = (o) ->
		defaults = 
			placeholderClass : 'placeholder'
		options = $.extend(defaults, o)
		
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
						color: '#6D6D6D'
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
				).insertAfter(@)

				$(@).val('').addClass options.placeholderClass

				# placeholder password holder
				pw_holder.click ->
					pw_holder.hide()
					$(@).prev('input[type="password"]').focus().addClass('typing').removeClass options.placeholderClass
					return
				$(@).focusin ->
					if $(@).hasClass options.placeholderClass
						pw_holder.hide()
						$(@).removeClass options.placeholderClass
					return
				$(@).focusout ->
					if $(@).val() is ''
						pw_holder.show()
						$(@).val('').addClass options.placeholderClass
					return

			# placeholder for input type text
			if $(@).attr('type') isnt 'password'
				placeholder_val = $(@).attr 'placeholder'
				$(@).css 
					color: '#6D6D6D'
					fontFamily: '"Segoe UI", sans-serif'
					fontSize: $(@).css 'font-size'
				$(@).focusin ->
					$(@).css 'color', '#000'
					$(@).removeClass options.placeholderClass
					$(@).val('').removeClass options.placeholderClass if $(@).val() is placeholder_val
					return
				$(@).focusout ->
					if $(@).val() is placeholder_val
						$(@).css 'color', '#6D6D6D'
						$(@).addClass options.placeholderClass
					else if $(@).val() is ''
						$(@).val(placeholder_val).removeClass options.placeholderClass
						$(@).css 'color', '#6D6D6D'
					else
						$(@).css 'color', '#000' 
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
			$input = $(@)
			$input.focusin ->
				$(@).addClass 'typing'
				return
			$input.focusout ->
				$(@).removeClass 'typing'
				return
		.placeholder()
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
			ma = if $(@).css('margin') isnt 'undefined' then $(@).css('margin') else 0
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
				$(@).siblings('span.select').html val
				if select_css
					$(@).siblings('span.select').html val 
				else if not select_css or select_css is 'undefined'
					$(@).siblings('span.select').removeClass 'submitted'
				$(@).attr 'title', val
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
			
			return
		# check if element no height
		check_ele_first = do ->
			$select.each ->
				flag = false
				if $(@).filter ':visible'
					flag = true
					$(@).height 'auto' if $(@).height() is 0
					if $(@).siblings('span.select').length
						$(@).siblings('span.select').height 'auto'
						$(@).siblings('span.select').width 'auto'
				$(@).do_ele_style() if flag
				return 
			return
		return
	# styled_select_Fx() end
	
	return
	# dom functions end
# coffee script end



