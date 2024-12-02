module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        frankfurter: ['"OPTIFrankfurter-Medium"', 'sans-serif'],
        mplus: ['"M PLUS Rounded 1c"', 'sans-serif'],
      },
    },
  },
  plugins: [require('daisyui')],
  daisyui: {
    darkTheme: false, // ダークテーマを無効化
    themes: [
      {
        mytheme: {
          'primary': '#1E3A8A',
          'secondary': '#F3F4F6',
          'accent': '#10B981',
          'font': '#111827',
          'base-100': '#FFFFFF', // 必須プロパティ (ベース背景カラー)
        },
      },
    ],
  },
};
