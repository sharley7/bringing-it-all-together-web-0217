class Dog
attr_accessor :id, :name, :breed

def initialize (id: nil, name: name, breed: breed)
  @id = id
  @name = name
  @breed = breed
end

def self.create_table
  sql = "CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"

  DB[:conn].execute(sql)
end

def self.drop_table
  sql = "DROP TABLE dogs;"

  DB[:conn].execute(sql)
end

def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"

    DB[:conn].execute(sql,name,breed,id)
  end

def save
   if
    self.id
      self.update
  else
        save = "INSERT INTO dogs (name, breed) VALUES (?, ?)"

        DB[:conn].execute(save, self.name, self.breed)

        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
      end
        self
    end

    def self.create (att_hash)
      new_name = att_hash[:name]
      breed_name = att_hash[:breed]
      self.new(name: new_name, breed: breed_name).save
    end

    def self.find_by_id(id_num)
      sql = "SELECT * FROM dogs WHERE id = ? LIMIT 1;"

     DB[:conn].execute(sql, id_num).map do |hash|
        self.new_from_db(hash)
      end.first
    end

    def self.new_from_db (arr)
      id = arr[0]
      name = arr[1]
      breed = arr[2]
      self.new(id: id, name: name, breed: breed)
    end

    def self.find_or_create_by (name:, breed:)
      dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)

      if !dog.empty?
        dog_arr = dog[0]
        dog = Dog.new(id: dog_arr[0], name: dog_arr[1], breed: dog_arr[2])
      else
        dog = self.create(name: name, breed: breed)
      end
      dog
      end

      def self.find_by_name (name)
        sql = DB[:conn].execute("SELECT * FROM dogs WHERE name = ?", name).map do | record |
          self.new_from_db(record)
        end.first
      end

end
