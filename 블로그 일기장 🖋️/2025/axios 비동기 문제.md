## 문제 개요

&emsp;&emsp;

- then절에서 요청을 보내면 비동기 순서 보장이 되지 않음


<br><br><br>

## 원인 분석

&emsp;&emsp;

- then절이 완전히 끝난 상태가 아닌데 그 속에서 또 다른 promise 요청을 하고 있다.

<br><br><br>


## 해결 방법

&emsp;&emsp;

- 요청을 다시 return 시키고 이를 기반으로 체이닝을 만들어준다.

&emsp;&emsp;

``` ts

const onClickLogin = (async () => {  
  userLogin({  
    accountId: username.value,  
    password: password.value,  
    roleType: isAdminPage.value ? "ADMIN" : "USER",  
  }).then(() => {  
    return userInfo();
  }).then((result: AxiosResponse<CommonResult<User>>)=>{  
    authStore().saveAccount(result.data.data);  
    router.push("/");  
  }).catch((error: AxiosCustomError) => {  
    errorMessage.value=error.message;  
  });  
})

```

