
class Person

  def name 
    puts "my name is person"
  end

end

class Studend < Person

  def age
    puts "my age is 18"
  end

end


st = Studend.new
st.name
st.age

