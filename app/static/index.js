const { createApp } = Vue;

createApp({
  data() {
      return {
          message: 'CONSOLE LOG RUN',
      }
  }, 
  methods: {
    getconsole() {
      console.log(message);
    }
  }
}).mount('#app')