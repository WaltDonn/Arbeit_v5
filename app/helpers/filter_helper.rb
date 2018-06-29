module FilterHelper
#######################     HIGH-STRENGTH FILTERS
#   # recursively remove all </?script> tags, then also remove ;
#   def sanitize(review)
#     recursive_remove(review, /(<script.*?>)|(<\/script>)/i).gsub(/;/,'')      
#   end
  
#   # recursively remove ../ to "prevent" path traversal, then remove etc/passwd or mdb :)
#   def filter_filename(filename)
#     recursive_remove(filename, /\.\.\//).gsub(/(etc\/passwd|mdb|shadow)/,'')
#   end
  
#   def filter_search(search)
#     recursive_remove(search, /(<script.*?>)|(<\/script>)|(\")/i).gsub(/;/,'')
#   end
  
#   def user_sanitize(search)
#     recursive_remove(search, /(<script.*?>)|(<\/script>)|(javascript)|(\")/i).gsub(/;/,'')
#   end
  
#   private
#   def recursive_remove(original_str, regex)
#     until clean ||= false
#       original_str = original_str.gsub(regex, '')
#       clean = original_str.match(regex).nil?
#     end
    
#     original_str
#   end


#######################     MEDIUM-STRENGTH FILTERS
  # remove all occurrences of </?script>
  def sanitize(review)
    xss_filter(review)
  end
  
  # remove ../ to "prevent" path traversal :)
  def filter_filename(filename)
    filename.gsub(/(\.\.\/)/, '')
  end
  
  def filter_search(search)
    xss_filter(search)
  end
  
  def filter_email(email)
    email.gsub(/\;(.*)/)
  end
  
  def user_sanitize(search)
    recursive_remove(search, /(<script.*?>)|(<\/script>)|(javascript)|(\")/i).gsub(/;/,'')
  end
  
  private
  def xss_filter(text)
    text.gsub(/(<script.*?>)|(<\/script>)|(\")/i, '')
    #text.gsub(/(<script.*?>)|(<\/script>)|(\")/, '')
  end
  
  def recursive_remove(original_str, regex)
    until clean ||= false
      original_str = original_str.gsub(regex, '')
      clean = original_str.match(regex).nil?
    end
    
    original_str
  end
end