class @Event
    constructor: ->
        $(document).keydown (event) ->
            if (String.fromCharCode(event.which).toLowerCase() == 's' and event.ctrlKey) or event.which == 19
                action.save_file()
                event.preventDefault()
                return false
            else if event.which == 27
                action.exit_full_window()
            return true

        $("#tabs").on "tabsactivate", (event, ui) ->
            uid = ui.newPanel.data('uid')
            editor = editors[uid]
            if editor
                editor = editor.editor
                editor.resize()
                editor.setShowInvisibles(true)
                editor.setShowInvisibles(false)

        window.onbeforeunload = () ->
            chrome.storage.local.set { 'path': document.title }
            paths = []
            for key, editor of editors
                paths.push editor.path
                filename = $("#link-#{editor.uid}").text()
                if filename.indexOf('* ') == 0
                    return """"#{filename.substr(2)}" #{chrome.i18n.getMessage('save_before_leaving')}"""
            chrome.storage.local.set { 'paths': paths }

        $('body').on 'click', '.file_link', ->
            action.open_file $(this).data('path')

        $('body').on 'click', '.folder_link', ->
            action.open_folder $(this).data('path')

        $('body').on 'click', '.options_btn', ->
            chrome.tabs.create { url: chrome.extension.getURL('html/options.html') }

        $('body').on 'click', "span.ui-icon-close", ->
            uid = $(this).closest("li").attr('aria-controls').substr(4)
            editors[uid].dispose()

        $('body').on 'click', '.full_window_btn', ->
            action.full_window()

        $('body').on 'click', '.save_btn', ->
            action.save_file()
        
        $('body').on 'click', '.new_file_btn', ->
            setTimeout((-> action.create_file()), 50)

        $('body').on 'click', '.new_folder_btn', ->
            setTimeout((-> action.create_folder()), 50)

        $('body').on 'click', '.find_btn', ->
            current_editor = util.current_editor()
            if current_editor
                ace.require('ace/ext/searchbox').Search(current_editor.editor)

        $('body').on 'click', '.replace_btn', ->
            current_editor = util.current_editor()
            if current_editor
                ace.require('ace/ext/searchbox').Search(current_editor.editor, true)

        $('body').on 'click', '.toggle_invisibles_btn', ->
            current_editor = util.current_editor()
            if current_editor
                current_editor.editor.setShowInvisibles(!current_editor.editor.getShowInvisibles())

class @Action
    open_file: (path) ->
        if not file_manager.exists(path)
            util.notice chrome.i18n.getMessage('does_not_exist'), path
            return
        for key, editor of editors
            if path == editor.path
                uid = editor.uid
                index = $('#tabs ul li').index $("#li-#{uid}")
                $('#tabs').tabs 'option', "active", index
                return
        application.open_file path

    open_folder: (path) ->
        if not file_manager.exists(path)
            util.notice chrome.i18n.getMessage('does_not_exist'), path
            return
        if not file_manager.can_list path
            util.notice chrome.i18n.getMessage('permission_denied'), path
            path = file_manager.home_folder() or file_manager.temp_folder()
        application.show_breadcrumb path
        application.show_sidebar path

    exit_full_window: ->
        if window.layout.state.north.isClosed
            window.layout.open 'north'

    full_window: ->
        if window.layout.state.north.isVisible
            window.layout.close 'north'

    save_file: ->
        current_editor = util.current_editor()
        if current_editor
            current_editor.save_file()

    create_file: ->
        file_path = util.prompt_path_name('file')
        return if not file_path
        file_manager.create_file file_path
        application.refresh_sidebar()
        action.open_file file_path

    create_folder: ->
        folder_path = util.prompt_path_name('folder')
        return if not folder_path
        file_manager.create_folder folder_path
        application.refresh_sidebar()


#
#$('body').on 'click', '.mode-link', ->
    #window.editor.getSession().setMode "ace/mode/#{$(this).data('mode')}"

#
#$('body').on 'click', '.about_btn', ->
    #util.notice "Slim Text #{chrome.app.getDetails().version}", "Copyright © 2012 - 2013 slimtext.org", 5000
#
#$('body').on 'change', '#drives_select', ->
    #window.open_path $(this).val()
#
#$('body').on 'click', '.remove_lines_btn', ->
    #window.editor.removeLines()
#
#$('body').on 'click', '.lower_case_btn', ->
    #window.editor.toLowerCase()
#
#$('body').on 'click', '.upper_case_btn', ->
    #window.editor.toUpperCase()
#
#$('body').on 'click', '.toggle_comment_btn', ->
    #window.editor.toggleCommentLines()
#
#$('body').on 'click', '.indent_btn', ->
    #window.editor.indent()
#
#$('body').on 'click', '.outdent_btn', ->
    #window.editor.blockOutdent()

#
#$('body').on 'click', '.toggle_word_wrap_btn', ->
    #window.editor.getSession().setUseWrapMode(!window.editor.getSession().getUseWrapMode())


#
#$('body').on 'click', '.check_for_updates_btn', ->
    #$.get('https://raw.github.com/tylerlong/slimtext.org/gh-pages/__version__', (data) ->
        #newest = data.trim()
        #current = chrome.app.getDetails().version
        #if newest > current
            #util.notice "#{chrome.i18n.getMessage('new_version')}: #{newest}", chrome.i18n.getMessage('fetch_and_install'), 8000
        #else
            #util.notice chrome.i18n.getMessage('no_update'), "#{chrome.i18n.getMessage('newest_version')}: #{current}", 5000
            #
    #).fail ->
        #util.notice chrome.i18n.getMessage('network_error'), chrome.i18n.getMessage('check_manually'), 5000
