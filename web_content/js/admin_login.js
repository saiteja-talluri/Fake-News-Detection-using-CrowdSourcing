var start = "localhost:8080/Infact/";
$(document).ready(function () {
    var xhttp;
    $("#LoginButton").click(function () {
        var email = $("#email_l").val();
        var pwd = $("#pwd_l").val();
        console.log(email, pwd)
        if (email == null || pwd == null) {
            alert("Email and Password should be non empty")
        } else
            $.post(
                'AdminLogin',
                {
                    emailid: email,
                    password: pwd
                },
                function (response, status) {
                    console.log(response)
                    console.log(status)
                    console.log(status=='success')
                    if (status == 'success' && response.status) {
                        console.log("Login Sucessfull ");
                        window.location.replace('admin_home.html')
                        // window.location = window.location.protocol + '//' + (start+"home.html");
                    } else {
                    	alert('Login Failed');
                        console.log("Login Failed: " + response);
                    }
                } 
            );
    });
    function validateEmail(email){
        var re = /\S+@\S+\.\S+/;
        return re.test(String(email).toLowerCase());
    }
});




