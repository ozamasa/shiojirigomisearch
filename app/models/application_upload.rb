class ApplicationUpload

  attr_accessor :filename
  attr_accessor :content_type
  attr_accessor :size
  attr_accessor :data

  def initialize(file)
    unless file.blank?
      begin
        @filename = file.original_filename.gsub(/[^\w!\#$%&()=^~|@`\[\]\{\};+,.-]/u, '')
        @content_type = file.content_type.gsub(/[^\w.+;=_\/-]/n, '')
        @size = file.size
        @data = file.read
      rescue
      end
    end
  end


  def to_a
    require 'csv'

    arrs = []
    CSV.parse(@data){|line|
      row = []
      line.each_with_index{|col,j|
        row << col
      }
      arrs << row
    }
    return arrs
  end


  def import(instance, instance2 = {}, instance3 = {})
    upload_msga  = []
    upload_cols  = instance.columns
    exclude_cols = ["id", "lock_version", "created_at", "updated_at", "hashed_password", "salt"]

    self.to_a.each_with_index{|row,i|
      if i > 0
        id = 0
        flag_new = false
        object = nil
        row.each_with_index{|data,j|
          data = Kconv.toutf8(data.to_s)
          if j == 0
            begin
              id = data.to_i
              object = instance.find(id)
            rescue
              if row[j+1].blank?
                upload_msga << "[#{i}]" + "データが空白のためスキップしました。"
                break
              end
              id = 0
              flag_new = true
              object = instance.new
              upload_cols.each{|col|
                if exclude_cols.index(col.name).blank?
                  object[col.name] = ""
                  object[col.name] = 0  if col.type.to_s == "integer"
                end
              }
            end

          elsif j > (upload_cols.size - 1)
            unless instance2.blank?
              begin
                object3 = instance3.find(data.to_i)
                object2 = instance2.new
                upload_cols2 = instance2.columns
                object2[upload_cols2[1].name] = id
                object2[upload_cols2[2].name] = data.to_i
                object2.save
              rescue
              end
            end

          else
            begin
              if exclude_cols.index(upload_cols[j].name).blank?
                begin
                  object[upload_cols[j].name] = data
                rescue
                  object[upload_cols[j].name] = ""
                end
              end
            rescue
            end

            if j == (upload_cols.size - 1)
              upload_msga << "[#{i}]" + object.errors.full_messages.to_s if object.invalid?

              if object.save
                id = object.id
                begin
                  object_name = object.name_with_id
                rescue
                  begin
                    object_name = sprintf("%s : %s", object.id, object.name)
                  rescue
                    object_name = object.id.to_s
                  end
                end
                upload_msga << "[#{i}]" + object_name + (flag_new ? "を追加しました。" : "を更新しました。")
              end

              unless instance2.blank?
                begin
                  object2ds = instance2.all(:conditions => {:user_id => object.id})
                  object2ds.each{|object2d|
#                    object2d.destroy
                  }
                rescue
                end
              end

            end
          end
        }
      end
    }

    upload_msgs = "\n" + upload_msga.join("\n") + "\n"
    return upload_msgs
  end

  def import_by_sql(table)
    msg = []
    col = []
    sql_header = ""
    sql = ""
    exd = ["id", "lock_version", "created_at", "updated_at"]

    self.to_a.each_with_index{|row,i|
      if i == 0
        sql_header = "insert into #{table} ("
        row.each_with_index{|data,j|
          if exd.index(data).blank?
            col << data
            sql_header += data  + ","
          end
        }
        sql_header = sql_header.slice(0, sql_header.size - 1)
        sql_header += ") values ("

      elsif i > 0
        sql = sql_header
        row.each_with_index{|data,j|
          if exd.index(data).blank?
            data = Kconv.toutf8(data.to_s)
            sql += "'" + data.gsub("'", " ") + "',"
          end
        }
        sql = sql.slice(0, sql.size - 1)
        sql += ")"

        begin
          ActiveRecord::Base.connection.execute(sql)
        rescue => e
          p e
        end

      end
    }
    return msg
  end

end
