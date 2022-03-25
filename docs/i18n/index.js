var en = require("./translations.en.json");
var cn = require("./translations.cn.json");

const i18n = {
  translations: {
    en,
    cn,
  },
  defaultLang: "en",
  useBrowserDefault: true,
};

module.exports = i18n;
