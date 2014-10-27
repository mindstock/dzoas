function update_status(id, status){
    var pd = ""
    var rpd = "123"
    if (status == 3){
      pd = prompt("请输入密码：")
      if(pd != rpd){
        alert("密码不正确！");
      }else{
        location.href = "/plans/spread/status/update/"+id+"/"+status
      }
    }else{
      location.href = "/plans/spread/status/update/"+id+"/"+status
    }
    
  };

  $("#size_phone_message").click(function (){
    var s='';
    var i = 0;
    $('input[name="plan_id"]:checked').each(function(){
      s+=$(this).val()+',';
      i += 1;
    });
    var employee_id = $('input[name="employee_id"]:checked').val();
    if(i > 3 || i < 1){
      alert("每次发送钢卷尺寸条数为1-3条");
    }else{
      location.href = "/plans/send/message?message="+s+"&employee_id="+employee_id;
    }
    
  });

  function phone_message(type_id){
    location.href = "/plans/send/message?type=1&employee_id="+type_id
  }

  function complete_plan(){
    var plan_id = $("#complete_plan_id").val();
    var pd = ""
    var rpd = "123"
    var sheet = $("#sheet").val();
    var is_nickelclad_top = $("#is_nickelclad_top").val();
    pd = prompt("请输入密码：")
    if(pd != rpd){
        alert("密码不正确！");
    }else{
      location.href = "/plans/spread/complete_plan/"+plan_id+"?sheet="+sheet+"&is_nickelclad_top="+is_nickelclad_top
      
    }
    
  }

  function complete_model(plan_id, nickelclad_id){
    $("#nickelclad_id").val(nickelclad_id);
    $("#complete_plan_id").val(plan_id);
    $('#complete').modal('show');
  };

  function up_tape_model(plan_id, tape_id){
    $("#tape_id").val(tape_id);
    $("#up_tape_form").attr("action","/plans/spread/update/plance_num/"+plan_id);
    $('#up_tape').modal('show');
  }



  function play_click(){
    var div = document.getElementById('music');
    div.src="http://qzone.haoduoge.com/music/1A8F9XC128EC2728A8516173DEA74B51E4D92.mp3";

  };