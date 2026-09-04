<template>
        <div v-show="!isEditMode">
            <h1>User Profile</h1>
            <img :src="image">
            
            <button v-if="!showImageUpload" @click="showImageUpload = true">Upload Picture</button>
            <div class="profile-img-upload" v-if="showImageUpload">
                <label for="profile-img-upload">Upload Profile Image:</label>
                <input id="profile-img-upload" type="file" accept="image/*" @change="handleImageUpload" />
            </div>


            <hr />
            <span>Name: </span><b id="name">{{ name }}</b>
            <hr />

            <span>Email: </span><b id="email">{{ email }}</b>
            <hr />

            <span>Interests: </span><b id="interests">{{ interests }}</b>
            <hr />

            <button @click="handleEditProfile">Edit Profile</button>
        </div>
        <div v-show="isEditMode">
            <h1>User Profile</h1>
             <img :src="image">

            <span>Name: </span>
            <input type="text" id="input-Name" v-model="name">
            <hr />

            <span>Email: </span>
            <input tpye="text" id="input-Email" v-model="email">
            <hr />

            <span>Interests: </span>
            <input type="text" id="input-Interests" v-model="interests">
            <hr />

            <button @click="handleUpdateProfile">Update Profile</button>
        </div>
</template>

<script>
import image from "./profile.jpeg"
export default {
    name: "App",
        data() {
            return {
                image: image,
                name: "",
                email: "",
                interests: "",
                isEditMode: false,
                showImageUpload: false
                }
            },
            async created() {
                const userData = await this.fetchUserProfile();
                this.name = userData.name
                this.email = userData.email
                this.interests = userData.interests
            },
        methods: {
            handleEditProfile() {
                this.isEditMode=true
            },
            handleImageUpload(event) {
                const file = event.target.files && event.target.files[0]
                if (!file) {
                    return
                }
                const reader = new FileReader()
                reader.onload = (e) => {
                    this.image = e.target.result
                    this.showImageUpload = false
                }
                reader.readAsDataURL(file)
            },
            async handleUpdateProfile() {
                const payload = {
                    name: this.name,
                    email: this.email,
                    interests: this.interests
                }
                const resJson = await this.updateUserProfile(payload)
                console.log(resJson)
                this.isEditMode = false
            },
            async parseJsonResponse(res) {
                const text = await res.text()
                try {
                    return JSON.parse(text)
                } catch {
                    return {}
                }
            },
            async fetchUserProfile() {
                const res = await fetch('/get-profile')
                return await this.parseJsonResponse(res)
            },
            async updateUserProfile(payload) {
                const res = await fetch('/update-profile', {
                    method: "POST",
                    headers: {
                        'Content-Type': 'application/json',
                        'Accept': 'application/json'
                    },
                    body: JSON.stringify(payload)
                })
                return await this.parseJsonResponse(res)
            }
        }
    }
</script>

<style>
img {
    width: 320px;
    height: auto;
    display: block;
    margin-bottom: 20px;
}

div {
    margin: 40px auto;
    width: 80%;
}

hr {
    width: 400px;
    margin: 25px 0;
}

button {
    width: 160px;
    font-size: 15px;
    height: 45px;
    border-radius: 5px;
}

button:hover {
    cursor: pointer;
}

input {
    width: 200px;
    font-size: 15px;
    padding: 10px;
}
</style>