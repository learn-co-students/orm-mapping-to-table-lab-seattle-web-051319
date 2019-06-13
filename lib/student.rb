class Student
  attr_accessor :name, :grade
  attr_reader :id

  def initialize(id = nil, name, grade)
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
            CREATE TABLE students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade TEXT
            );
            SQL
            DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = <<-SQL
            DROP TABLE IF EXISTS students;
            SQL
            DB[:conn].execute(sql)
  end

  def save
    sql = <<-SQL
            INSERT INTO students (name, grade)
            VALUES (?, ?);
            SQL
            DB[:conn].execute(sql, self.name, self.grade)

    @id = DB[:conn].execute("SELECT  last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    #takes in a hash of attributes and uses metaprogramming
    #to create a new student object
    student = Student.new(name, grade)
    student.save
    #uses the #save method (defined above) to save new
    #student instance
    student
    #returns the new student object that was just instantiated
  end

end


# Remember, you can access your database connection anywhere in this class
#  with DB[:conn]
