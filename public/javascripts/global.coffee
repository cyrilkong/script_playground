doc = document
$dom = $(document)
# dom ready()
$dom.ready ->
	# device/browser detection
	isFirefox = $.browser.mozilla
	isSafari = $.browser.safari
	isWebkit = $.browser.webkit
	docBody = if isWebkit then 'body' else 'html'
	isIE7 = $.browser.msie and $.browser.version is 7.0
	isIE8 = $.browser.msie and $.browser.version is 8.0
	deviceAgent = navigator.userAgent.toLowerCase()
	isMobile = deviceAgent.match /(iphone|ipod|ipad|android)/ isnt null

	# eqHeight()
	$.fn.eqHeight = (minH, maxH)->
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
		testinput = doc.createElement 'input'
		$.extend $.support,	placeholder : !!('placeholder' of testinput)
		# stop it if can native support placeholder
		$(@).each ->
			return false if $.support.placeholder

		should_value = $(@).attr 'placeholder'
		cur_value = $(@).attr 'value'
		$(@).attr 'autocomplete', 'off'
		$(@).addClass options.placeholderClass if should_value is cur_value

		if cur_value is ''
			$(@).addClass options.placeholderClass
			$(@).val should_value

		# placeholder for input type password
		if $(@).attr 'type' is 'password'
			placeholder_val = $(@).attr 'placeholder'
			pw_holder = $('<span />',
				text: placeholder_val,
				'class': options.placeholderClass,
				css:
					position: 'aboslute'
					fontFamily: '"Segoe UI", sans-serif'
					background: 'transparent'
					cursor: 'text'
					border: 'none'
					top: $(@).position().top
					left: $(@).position().left
					lineHeight: $(@).height() + 3 +'px'
					paddingLeft: parseFloat $(@).css 'paddingLeft' + 2 +'px'
			).insertAfter(@)

			$(@).val('').addClass options.placeholderClass

			# placeholder password holder
			pw_holder.click ->
				pw_holder.hide()
				$(@).prev('input[type="password"]').focus().addClass('typing').removeClass 'placeholder'
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
		if $(@).attr 'type' isnt 'password'
			$(@).focusin ->
				placeholder_val = $(@).attr 'placeholder'
				$(@).removeClass options.placeholderClass
				$(@).val(placeholder_val).removeClass options.placeholderClass if placeholder_val is $(@).val()
				return
			$(@).focusout ->
				placeholder_val = $(this).attr 'placeholder'
				$(this).removeClass options.placeholderClass
				$(@).val(placeholder_val).removeClass optoins.placeholderClass if $(@).val() isnt '' and not placeholder_val
				$(@).addClass options.placeholderClass if $(@).val() is placeholder_val
				return

		# placeholder for input end, form submit handler
		$(@).parents('form').submit ->
			$(@).find('[placeholder]').each ->
				input = $(@)
				input.val('') if input.val() is input.attr 'placeholder'
				return
			return
	# placeholder() end

	# placeholder_init()
	placeholder_init = do ->
		$('.placeholder', '[placeholder]').each ->
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
		return false if not $dom.find('select').length

		$('select.styled').each ->
			select_title = $(@).attr 'title'
			ma = if $(@).css('margin') isnt 'undefined' then $(@).css('margin') else 0
			$(@).css
				border: '1px solid transparent'
				margin: ma
			ot = $(@).offset().top - 2
			ol = $(@).offset().left - 2
			if $('option:selected', @).val() isnt ''
				select_title = $('option:selected', @).text()
				$(@).width $(@).width() + 20
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
		return
	# styled_select_Fx() end


	
	return
	# dom functions end
# coffee script end



