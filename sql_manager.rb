require 'pry'
require 'sqlite3'
# => Worked with George

class Book
  attr_accessor :title, :page_count, :genre, :price
  attr_reader :id

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS books (
        id INTEGER PRIMARY KEY,
        title TEXT,
        page_count INTEGER,
        genre TEXT,
        price INTEGER
      )
    SQL

    db.execute(sql)
  end

  def initialize(attributes = {})
    @id = attributes[:id]
    @title = attributes[:title]
    @page_count = attributes[:page_count]
    @genre = attributes[:genre]
    @price = attributes[:price]
  end

  def self.db
    @@db ||= SQLite3::Database.new "literature.db"
  end
  
  def self.all
    sql = <<-SQL
    SELECT * FROM books;
    SQL

    rows = db.execute(sql)
    rows.map do |row|
      self.book_from_row(row)
    end
  end

  def save
    sql = <<-SQL
      INSERT INTO books (title, page_count, genre, price)
      VALUES (?, ?, ?, ?)
    SQL
    db.execute(sql, self.title, self.page_count, self.genre, self.price)
    @id = db.execute("SELECT last_insert_rowid() FROM books")[0][0]
  end

  def ==(other_object)
    self.id == other_object.id
  end


  def destroy
    sql = <<-SQL
      DELETE * FROM books WHERE id = ?
    SQL
    db.execute(sql, self.id)
  end


  def self.find(id)
    sql = <<-SQL
    SELECT * FROM books WHERE id = ?;
    SQL
    db.execute(sql, self.id)
  end


  def self.book_from_row(row)
      Book.new(id: row[0], title: row[1], page_count: row[2], genre: row[3], price: row[4])
  end

  private

  def insert

    sql = <<-SQL
      INSERT INTO books (title, page_count, genre, price) VALUES (?, ?, ?, ?)
    SQL
    db.execute(sql, self.title, self,page_count, self.genre, self.price)
#   @id = db.execute("SELECT last_insert_rowid() FROM books")
    
  end

  def update(title = @title, page_count = @page_count, genre = @genre, price = @price)
    @title = title
    @page_count = page_count
    @genre = genre
    @price = price
    sql = <<-SQL
      UPDATE books SET (title, page_count, genre, price) VALUES (?, ?, ?, ?) where id = ?
    SQL
    db.execute(sql, @title, @page_count, @genre, @price, self.id)
  end
end


Pry.start
