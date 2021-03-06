class @FileManager
    constructor:  ->
        @file_manager = document.getElementById('file_manager')

    combine: (path1, path2) ->
        @file_manager.combine path1, path2

    container: (path) ->
        @file_manager.container path

    filename: (path) ->
        @file_manager.filename path

    read: (path) ->
        @file_manager.read path

    extension: (filename) ->
        @file_manager.extension filename

    write: (path, content) ->
        @file_manager.write path, content

    valid_name: (filename) ->
        @file_manager.valid_name filename

    exists: (path) ->
        @file_manager.exists path

    type: (path) ->
        @file_manager.type path

    create_file: (path) ->
        @write path, ''

    create_folder: (path) ->
        @file_manager.create_folder path

    route: (path) ->
        @file_manager.route path

    can_list: (path) ->
        @file_manager.can_list

    home_folder: ->
        @file_manager.home_folder()

    temp_folder: ->
        @file_manager.temp_folder()

    drives: ->
        @file_manager.drives()

    list: (path) ->
        @file_manager.list path
