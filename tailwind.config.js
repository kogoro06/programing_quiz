module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js',
  ],
  theme: {
    extend: {
      colors: {
        html: '#FFB27A',
        css: '#94F2F8',
        js: '#F9E669',
        ruby: '#FF9999',
        git: '#6BF5C7',
        error: '#E6AFE1',
        react: '#61DAFB',
        java: '#41B883',
        laravel: '#FF2D20',
      },
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
