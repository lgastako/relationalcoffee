rel = require "./relational"


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


# SELECT manufacturer_id, MIN(price) as min_price
# FROM products
# GROUP BY manufacturer_id
console.log "\nmin price aggregation:\n", products.group_by "manufacturer_id", {
    min_price: rel.agg_min("price")
}


# SELECT manufacturer_id, MAX(price) AS max_price
console.log "\nmax price aggregation:\n", products.group_by "manufacturer_id", {
    max_price: rel.agg_max("price")
}


# SELECT manufacturer_id, SUM(price) AS total_price
console.log "\ntotal price (sum) aggregation:\n", products.group_by "manufacturer_id", {
    total_price: rel.agg_sum("price")
}

# SELECT manufacturer_id, COUNT(price) AS num_prices
console.log "\ncount of prices aggregation:\n", products.group_by "manufacturer_id", {
    num_prices: rel.agg_count("price")
}

# SELECT manufacturer_id, AVG(price) as avg_price
console.log "\navg price aggregation:\n", products.group_by "manufacturer_id", {
    avg_price: rel.agg_avg("price")
}


# SELECT manufacturer_id,
#        MIN(price) AS min_price,
#        MAX(price) AS max_price,
#        SUM(price) AS total_price,
#        COUNT(price) AS num_prices,
#        AVG(price) AS avg_price
# FROM products
# GROUP BY manufacturer_id
console.log "\ncombined aggregation:\n", products.group_by "manufacturer_id", {
    min_price: rel.agg_min("price")
    max_price: rel.agg_max("price")
    total_price: rel.agg_sum("price")
    num_prices: rel.agg_count("price")
    avg_price: rel.agg_avg("price")
}
