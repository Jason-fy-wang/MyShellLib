
# array
arr1 = [1,2,3,4]

# iteral array
arr1.each do |it|
    print "#{it} \n"
end

kv1 = {
    "key1":"value1",
    "key2":"values"
}


#iteral hash struct
kv1.each do |k, v| 
    print "key #{k}, val #{v} \n"
end


# method
def Sum arr
    res = ""
    arr.each do |val|
        res += val.to_s
    end
    res
end

val = Sum arr1

puts val


# named arguments
def Sum2 arr:
    res = ""
    arr.each do |val|
        res += val.to_s
    end
    res
end

## pass named parameter
puts Sum2 arr:arr1



