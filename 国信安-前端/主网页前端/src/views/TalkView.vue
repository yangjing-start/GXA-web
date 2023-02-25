<template>
    <div :style="background" class="bgBackground">
        <div class="con">
            <button>
                <a href="http://43.142.156.137:8000">进入</a>
            </button>
        </div>
        <div class="foot">
            这是一个可以寻找朋友进行在线问答的功能
        </div>
        <div class="tip">
          (进入后左边按钮是充当提出问题的角色，右边按钮是充当回复问题的角色，然后点击进行匹配)
        </div>
      </div>
  </template>
  

<script>
  import { ref } from '@vue/reactivity'
  export default{
    name:"TalkView",
    setup(){
      let background = ref({
        // 背景图片地址
        backgroundImage: 'url(' + require('../assets/5.jpeg') + ')',
        // 背景图片是否重复
        backgroundRepeat: 'no-repeat',
        // 背景图片大小
        backgroundSize: 'cover',
        // 背景颜色
        backgroundColor: '#000',
        // 背景图片位置
        backgroundPosition: 'center top'
      })
  
      return {
        background,
      }
    }
  }
  </script>
  
  <style scoped>
  .bgBackground{
      width:100%;
      height:100%;
      position: fixed;
      overflow: auto;
    }
    a{
        font-size: 40px;
        color: wheat;;
        text-decoration:none ;
    }

    button{
        width: 200px;
        height: 200px;
        background-color: red;
        border-radius: 50%;
        border: none;
    }
    .con{
        margin-left: 42%;
        margin-top: 150px;
    }
    .foot{
        margin-left: 30%;
        margin-top: 100px;
        color: black;
        font-size: 30px;
    }
    .tip{
      margin-left: 20%;
      color: red;
      font-size: 25px;
    }
  </style>
  