extend = (target, extensions...) ->
    for extension in extensions
        for name, value of extension
            target[name] = value
    target


_build = (rel, attr) ->
    hash = {}
    for tuple in rel
        if tuple[attr]?
            key = tuple[attr]
            hash[key] = tuple
    hash


_probe = (l_rel, l_attr, r_hash) ->
    for tuple in l_rel
        if tuple.hasOwnProperty l_attr
            l_key = tuple[l_attr]
            r_vals = r_hash[l_key]
            if r_vals?
                extend tuple, r_vals
    l_rel


Array.prototype.hash_join = (r_rel, l_attr, r_attr) ->
    # Assumes inner join

    l_rel = this.slice 0
    r_attr = r_attr or l_attr
    r_hash = _build r_rel, r_attr
    _probe l_rel, l_attr, r_hash, r_attr



_rename_tuple = (tuple, mapping) ->
    new_tuple = {}
    for name, value of tuple
        if name of mapping
            alias = mapping[name]
        else
            alias = name
        new_tuple[alias] = value
    new_tuple


Array.prototype.rename = (mapping) ->
    for tuple in this
        _rename_tuple tuple, mapping



_project_tuple = (tuple, cols) ->
    new_tuple = {}
    for col in cols
        new_tuple[col] = tuple[col]
    new_tuple



_unproject_tuple = (tuple, cols) ->
    new_tuple = {}
    for name, val of tuple
        if name not in cols
            new_tuple[name] = val
    new_tuple


Array.prototype._project = (f, cols) ->
    projection = for tuple in this
        f tuple, cols


Array.prototype.project = (cols...) -> this._project _project_tuple, cols
Array.prototype.unproject = (cols...) -> this._project _unproject_tuple, cols


matches_all_predicates = (tuple, predicates) ->
    for predicate in predicates
        if not predicate tuple
            return false
    true


Array.prototype.select = (predicates...) ->
    new_rel = []
    for tuple in this
        if matches_all_predicates tuple, predicates
            new_rel.push tuple
    new_rel


Array.prototype.where = Array.prototype.select

Array.prototype.crossproduct = (rels...) ->
    results = []
    other = rels[0]
    for tup1 in this
        for tup2 in other
            newtup = {}
            for name, value of tup1
                newtup[name] = value
            for name, vale of tup2
                newtup[name] = vale
            results.push newtup
    if rels.length > 1
        return results.crossproduct rels[1..]
    else
        return results
