const baseUrl = "https://jsonplaceholder.typicode.com/";

const form = document.getElementById("form");
const message = document.getElementById("message");
const title = document.getElementById("title");

// Given a response JSON, make a user object with retrievable attributes
const constructUser = (obj) => {
    if (obj.id && obj.name && obj.email)
    return {
        name: obj.name, email: obj.email, id: obj.id
    }
}

async function submitHandler(event) {
    event.preventDefault();
    const path = form[0].value;
    console.log(path);
    // Hide the form
    form.classList.add("invisible");
    message.innerText = `Loading "${path}"...`;
    const res = await (await fetch(baseUrl + path)).json();
    const user = constructUser(res);
    // Clear the text field
    if (res) form[0].value = "";
    // Set the title
    title.innerText = user.name;
    // Show the user's details
    message.innerText = `Email: ${user.email}\nName: ${user.name}\nID: ${user.id}`;
    // Show the form
    form.classList.remove("invisible");
}
form.addEventListener("submit", submitHandler, true);