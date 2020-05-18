var start  = "localhost:8080/Infact/";
$(document).ready(function () {
    var xhttp;
        $("#LoginButton").click(function () {
            var email= $("#email_l").val();
            var pwd=$("#pwd_l").val();
            console.log(email,pwd)
            if(email==null || pwd ==null){
                alert("Email and Password should be non empty")
            }else   
            	
            $.post("UserLogin",
            		{
                email_id : email,
                password : pwd
            },function (response,status){
//            	console.log(response.status);
            	if(status == 'success' && response.status){
            		console.log("Login Sucessfull ");
            		window.location.replace('home.html')
//                	window.location = window.location.protocol + '//' + (start+"home.html");
            	}else {
            		alert("Sorry Login Failed");
            		console.log("Login Failed: "+response);
            	}
            }
            		);
//            xhttp = new XMLHttpRequest();
//              xhttp.onreadystatechange = function() {
//                if (this.readyState == 4 && this.status == 200) {
//                    
//                    var msg_status = JSON.parse(this.responseText).status;
//                    console.log(msg_status);
//                    if(msg_status == true){  
//                    	console.log("Login Sucessfull ");
//                    	
//                    	window.location = window.location.protocol + '//' + (start+"home.html");
//                    }
//                    else { alert("Failed to to Login");}
//                }else{
//                    console.log("Login Failed: "+this.responseText +this.status + " "+ this.readyState);
//                }
//              };
//              var endpoint = "UserLogin";
//              //console.log(endpoint);
//              var data = {
//                  'email_id' : email,
//                  'password' : pwd
//              };
//              xhttp.open("POST",endpoint , true);
//              xhttp.setRequestHeader("Content-Type", "application/json;charset=UTF-8");
//              xhttp.send(JSON.stringify(data));
        });
        
        
        $("#CreateAccount").click(function () {
            var email= $("#email_c").val();
            var name = $("#name_c").val();
            var pwd1=$("#pwd1_c").val();
            var pwd2=$("#pwd2_c").val();
            var phonenumber = $("#phonenumber_c").val();
            
            if(email == null || name == null || phonenumber == null || pwd1 == null || pwd2 == null){
                alert("Please enter all the Fields");
            }else {
            if(pwd1 != pwd2){
                alert("Passwords don't Match");
            }else{
                if(!validateEmail(email)){
                    alert("Please Enter a Valid Email");
                }else{
                    console.log("Sending the request");
                    $.post("Register",{
                        name: name,
                        email:email,
                        phonenumber:phonenumber,
                        password: pwd1
                    },function(data,status){
                        
                        if (status == "success") {
                            console.log(data);
                            var msg_status = data["status"];
                            console.log(msg_status);
                            if(msg_status == true){  
                                console.log("Created Account Sucessfull ");
                                // window.location = window.location.protocol + '//' + (start+"index.html");
                                alert("Created Account Sucessfull");
                            }
                            else { alert("Failed to Create Account");}
                        }else{
                            console.log("Create Account Failed: "+this.responseText +this.status + " "+ this.readyState);
                        }
                });
            }
        }
    }
});

    function validateEmail(email){
        var re = /\S+@\S+\.\S+/;
        return re.test(String(email).toLowerCase());
    }

});




