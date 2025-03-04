// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function setTimeout(callback, delay) {
  const start = new Date().getTime();

  while (new Date().getTime() < start + delay);

  callback();
}

function Person(name, age) {
  this.name = name;
  this.age = age;

  this.greet = function() {
    console.log('Hello!');
  };
}

const person = new Person('John', 30);

function fetchData() {
  return new Promise((resolve, reject) => {

    setTimeout(() => {

      const isError = true;

      if (isError) {
        reject();
      } else {
        resolve('Get Data Success');
      }
    }, 2000);
  });
}

function handleRejection(error) {
  return new Promise((resolve, reject) => {

    setTimeout(() => {
      console.log('Async Process Rejected:', error.message);
      resolve();
    }, 1000);
  });
}

fetchData()
  .then((data) => {
    console.log('Success:', data);
  });

