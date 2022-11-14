const { createApp } = Vue;

createApp({
  data() {
      return {
          loading:false,
      }
  }, 
  methods: {
    getLoader() {
      var output = document.getElementById("story");

      output.innerText = "";

      if(output.value == ""){
        this.loading = true;
      }else {
        this.loading = false;
      }
    }
  }
}).mount('#app')