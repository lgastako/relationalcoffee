_build = (rel, attr) ->
    hash = {}
    for row in rel
        if row[attr]?
            key = row[attr]
            hash[key] = row
    hash


_probe = (l_rel, l_attr, r_hash) ->
    for row in l_rel
        if row.hasOwnProperty l_attr
            l_key = row[l_attr]
            r_vals = r_hash[l_key]
            if r_vals?
                for name, value of r_vals
                    row[name] = value
    l_rel


hash_join = (l_rel, r_rel, l_attr, r_attr) ->
    # Assuming l_rel and r_rel are arrays of objects
    # And l_attr is the attr on the l_rel to match to r_attr on the r_rel
    # Assumes inner join

    r_attr = r_attr or l_attr

    r_hash = _build r_rel, r_attr

    _probe l_rel, l_attr, r_hash, r_attr


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

console.log "results:\n", results
