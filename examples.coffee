require "./relational"


products = [
    {
        manufacturer_id: 1
        title: "iPad 8gb black"
        price: 69.95
    }
    {
        manufacturer_id: 1
        title: "iPad 16gb black"
        price: 89.95
    }
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
    }
    {
        manufacturer_id: 2
        manufacturer_name: "Samsung"
    }
]


#     SELECT *
#     FROM products, manufacturers
#     WHERE products.manufacturer_id = manufacturers.manufacturer_id
# or
#     SELECT *
#     FROM products INNER JOIN manufacturers USING manufacturer_id
results = products.hash_join manufacturers, "manufacturer_id"

# Change
#    "SELECT *"
# to
#    "SELECT title, price, manufacturer_name"
# using the Tutorial D style inversion projection
# (i.e. "ALL BUT manufacturer_id").
results = results.unproject "manufacturer_id"

console.log "products with manufacturers:\n", results


# SELECT manufacturer_name AS manufacturer
# FROM results
console.log "\njust manufacturers:\n", results.project("manufacturer_name").rename
    manufacturer_name: "manufacturer"


# SELECT *
# FROM products AS p
# WHERE p.manufacturer_id = 2
console.log "\nproducts by samsung:\n", products.where (p) -> p.manufacturer_id == 2


console.log "\nproducts that dont start with G:\n", products.where (p) -> p.title? and p.title[0] != "G"
console.log "\nproducts over $100:\n", products.where (p) -> p.price > 100

rel1 = [{a: "b", c: "d"}, {a: "e", c: "f"}]
rel2 = [{g: "h", i: "j"}, {g: "k", i: "l"}]


# SELECT *
# FROM rel1, rel2
console.log "\nrel1 crossproduct rel2:\n", rel1.crossproduct rel2


agg_max = (col) ->
    (tuples) ->
        result = tuples[0][col]
        for tuple in tuples[1..]
            val = tuple[col]
            if val > result
                result = val
        result

agg_min = (col) ->
    (tuples) ->
        result = tuples[0][col]
        for tuple in tuples[1..]
            val = tuple[col]
            if val < result
                result = val
        result


agg_sum = (col) ->
    (tuples) ->
        result = tuples[0][col]
        for tuple in tuples[1..]
            result = result + tuple[col]
        result


agg_count = (col) ->
    (tuples) ->
        result = 0
        for tuple in tuples
            val = tuple[col]
            if val?
                result += 1
        result


agg_avg = (col) ->
    # Not efficient, but we can optimize later
    (tuples) ->
        agg_sum(col)(tuples) / agg_count(col)(tuples)


Array.prototype.group_by = (cols, aggs) ->
    if typeof cols == "string"
        cols = [cols]
    groups = {}
    for tuple in this
        vals = (tuple[col] for col in cols)
        if not groups[vals]?
            groups[vals] = []
        groups[vals].push tuple
    results = []
    for _, tuples of groups
        new_tup = {}
        for col in cols
            new_tup[col] = tuples[0][col]
        for name, expr of aggs
            new_tup[name] = expr tuples
        results.push new_tup
    results


console.log "\nmin price aggregation:\n", products.group_by "manufacturer_id", {
    min_price: agg_min("price")
}

console.log "\nmax price aggregation:\n", products.group_by "manufacturer_id", {
    max_price: agg_max("price")
}

console.log "\ntotal price (sum) aggregation:\n", products.group_by "manufacturer_id", {
    total_price: agg_sum("price")
}

console.log "\ncount of prices aggregation:\n", products.group_by "manufacturer_id", {
    num_prices: agg_count("price")
}

console.log "\navg price aggregation:\n", products.group_by "manufacturer_id", {
    avg_price: agg_avg("price")
}


console.log "\ncombined aggregation:\n", products.group_by "manufacturer_id", {
    min_price: agg_min("price")
    max_price: agg_max("price")
    total_price: agg_sum("price")
    num_prices: agg_count("price")
    avg_price: agg_avg("price")
}
