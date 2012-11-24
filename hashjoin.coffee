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
                for name, value of r_vals
                    tuple[name] = value
    l_rel


hash_join = (l_rel, r_rel, l_attr, r_attr) ->
    # Assuming l_rel and r_rel are arrays of objects
    # And l_attr is the attr on the l_rel to match to r_attr on the r_rel
    # Assumes inner join

    r_attr = r_attr or l_attr

    r_hash = _build r_rel, r_attr

    _probe l_rel, l_attr, r_hash, r_attr


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


_project = (f, rel, cols) ->
    projection = []
    for tuple in rel
        new_tuple = f tuple, cols
        projection.push new_tuple
    projection


project = (rel, cols) -> _project _project_tuple, rel, cols
unproject = (rel, cols) -> _project _unproject_tuple, rel, cols


select = (rel, predicates...) ->
    new_rel = []
    for tuple in rel
        if matches_all_predicates tuple, predicates
            new_rel.push tuple
    new_rel

where = select

products = [
    {
        manufacturer_id: 1
        title: "iPad 8gb black"
        price: 69.95
    },
    {
        manufacturer_id: 1
        title: "iPad 16gb black"
        price: 69.95
    },
    {
        manufacturer_id: 2
        title: "Galaxy Tab"
        price: 349.95
    }
]

manufacturers = [
    {
        manufacturer_id: 1
        manufacturer_name: "Apple"
    },
    {
        manufacturer_id: 2
        manufacturer_name: "Samsung"
    }
]

results = hash_join products, manufacturers, "manufacturer_id"

results = unproject results, ["manufacturer_id"]

console.log "results:\n", results

# results = project results, ["manufacturer_name", "title"]
# # results = unproject results, "manufacturer_id"
# console.log "results:\n", results
