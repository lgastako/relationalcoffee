function hash_join(l_rel, r_rel, l_attr, r_attr) {
    // Assuming l_rel and r_rel are arrays of objects
    // And l_attr is the attr on the l_rel to match to r_attr on the r_rel
    // Assumes inner join

    if (!!r_attr) {
        r_attr = l_attr;
    }

    // Build
    r_hash = {}
    for (var row in r_rel) {
        console.log("row: " + row);
        if (r_rel.hasOwnProperty(row)) {
            r_rel[]
            if (row.hasOwnProperty(r_attr)) {
                var r_key = row[r_attr];
                r_hash[r_key] = row;
            }
        }
    }

    console.log(r_hash);

    // Probe
    for (l_row in l_rel) {
        if (l_rel.hasOwnProperty(row)) {
            if (row.hasOwnProperty(l_attr)) {
                var l_key = row[l_attr];
                var r_vals = (r_hash[l_key] || {});
                for (r_key in r_vals) {
                    if (r_vals.hasOwnProperty(r_key)) {
                        l_row[r_key] = r_vals[r_key];
                    }
                }
            }
        }
    }

    return l_rel;
}


var products = [
    {
        manufacturer_id: 1,
        title: "iPad 8gb black",
        price: 69.95
    },
    {
        manufacturer_id: 1,
        title: "iPad 16gb black",
        price: 69.95
    },
    {
        manufacturer_id: 2,
        title: "Galaxy Tab",
        price: 349.95
    }
];

var manufacturers = [
    {
        manufacturer_id: 1,
        manufacturer_name: "Apple"
    },
    {
        manufacturer_id: 2,
        manufacturer_name: "Samsung"
    }
];

var results = hash_join(products, manufacturers, "manufacturer_id");

console.log(results);
