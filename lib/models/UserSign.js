const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
    profile_picture: { type: String, required: true },
  name: { type: String, required: true },
  email: { type: String, required: true },
  phone: { type: Number, required: true },
  address: { type: String, required: true },
  password: { type: String, required: true },
  confirm_password: { type: String, required: true },
});

module.exports = mongoose.model('User', userSchema);
