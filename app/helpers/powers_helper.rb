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

  def get_navigation cur_menu
    menu = user_session[:menu]
    @htmlmenu = ""
    @htmlmenu.concat("<ul show='true'>")
    is_menu = false
    @root = Power.where(parent_id: 0)
    @root.each do |item|
        if item.subordinates.length > 0
          @htmlmenu.concat("<li><a　href='#' ref='#{item.name}'>")
        else
          @htmlmenu.concat("<li><a　href='#{item.url}' ref='#{item.name}'>")
        end
        @htmlmenu.concat(item.name)
        @htmlmenu.concat("</a></li>")
        is_menu = true if item.id = cur_menu
        buildmenu item, is_menu
        @htmlmenu.concat("</li>")
      end
      @htmlmenu.concat("</ul>")
      @htmlmenu
  end

  def buildmenu power, is_menu
    @children = power.subordinates
    if @children.size != 0
      @htmlmenu.concat("<ul show='false'>")
      @children.each do |item|
        if item.subordinates.length != 0
          @htmlmenu.concat("<li><a　href='#' ref='#{item.name}'>")
        else
          @htmlmenu.concat("<li><a href='#{item.url}' ref='#{item.name}'>")
        end
        @htmlmenu.concat(item.name)
        @htmlmenu.concat("</a></li>")
        buildmenu item, is_menu
        @htmlmenu.concat("</li>")
      end
      @htmlmenu.concat("</ul>")
    end
  end
end
