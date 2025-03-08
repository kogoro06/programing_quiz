import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "choice1", "choice2", "choice3", "choice4"]

  async generateWrongChoices(event) {
    const button = event.currentTarget
    const questionIndex = button.dataset.questionIndex
    
    // 問題文を取得
    const questionEditor = document.querySelector(`#quiz_questions_attributes_${questionIndex}_question`)
    const questionText = questionEditor?.value

    // 既に入力されている選択肢を取得
    const existingChoices = []
    for (let i = 1; i <= 4; i++) {
      const choiceField = document.querySelector(`#quiz_questions_attributes_${questionIndex}_choices_attributes_0_choice${i}`)
      const choiceValue = choiceField?.value?.trim()
      if (choiceValue) {
        existingChoices.push(choiceValue)
      }
    }

    if (!questionText || existingChoices.length === 0) {
      alert('問題文と少なくとも1つの選択肢を入力してから残りの選択肢を生成してください')
      return
    }

    button.disabled = true
    button.innerHTML = '<span class="loading loading-spinner"></span> 生成中...'

    try {
      const response = await fetch('/quiz_posts/generate_wrong_choices', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
        },
        body: JSON.stringify({
          question: questionText,
          existing_choices: existingChoices
        })
      })

      const data = await response.json()

      if (data.status === 'success' && data.choices?.length > 0) {
        // 空の選択肢フィールドに生成された選択肢を順番に設定
        let choiceIndex = 1
        let generatedIndex = 0
        while (choiceIndex <= 4 && generatedIndex < data.choices.length) {
          const choiceField = document.querySelector(`#quiz_questions_attributes_${questionIndex}_choices_attributes_0_choice${choiceIndex}`)
          if (!choiceField.value.trim()) {
            choiceField.value = data.choices[generatedIndex]
            generatedIndex++
          }
          choiceIndex++
        }
      } else {
        throw new Error('選択肢の生成に失敗しました')
      }
    } catch (error) {
      console.error('Error:', error)
      alert('選択肢の生成中にエラーが発生しました。もう一度お試しください。')
    } finally {
      button.disabled = false
      button.innerHTML = '<span class="material-icons mr-2">auto_fix_high</span>残りの選択肢を生成'
    }
  }
} 