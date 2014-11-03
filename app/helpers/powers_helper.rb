module PowersHelper
	def mkdirs(path)
	    if(!File.directory?(path))
	        if(!mkdirs(File.dirname(path)))
	            return false;
	        end
	        Dir.mkdir(path)
	    end
	    return true
  end

  def get_navigation cur_menu, power_ids
    @htmlmenu = ""
    @htmlmenu.concat("<div class='st_tree'>")
    @htmlmenu.concat("<ul show='true'>")
    is_menu = false
    @root = Power.where(parent_id: 0)
    @root.each do |item|
        next unless power_ids.include? item.id
        if item.subordinates.length > 0
          @htmlmenu.concat("<li><a href='#' ref='#{item.name}'>")
        else
          @htmlmenu.concat("<li><a href='#{item.url}' ref='#{item.name}'>")
        end
        @htmlmenu.concat(item.name)
        @htmlmenu.concat("</a></li>")
        if item.id == cur_menu.to_i
          is_menu = true
        else
          is_menu = false
        end
        buildmenu item, is_menu, power_ids
        @htmlmenu.concat("</li>")
    end
      @htmlmenu.concat("</ul>")
      @htmlmenu.concat("</div>")
      @htmlmenu
  end

  def buildmenu power, is_menu, power_ids
    @children = power.subordinates
    if @children.size != 0
      if is_menu
        @htmlmenu.concat("<ul show='true'>")
      else
        @htmlmenu.concat("<ul>")
      end
      
      @children.each do |item|
        next unless power_ids.include? item.id
        if item.subordinates.length != 0
          @htmlmenu.concat("<li><a href='#' ref='#{item.name}'>")
        else
          @htmlmenu.concat("<li><a href='#{item.url}' ref='#{item.name}'>")
        end
        @htmlmenu.concat(item.name)
        @htmlmenu.concat("</a></li>")
        buildmenu item, is_menu, power_ids
        @htmlmenu.concat("</li>")
      end
      @htmlmenu.concat("</ul>")
    end
  end
end
