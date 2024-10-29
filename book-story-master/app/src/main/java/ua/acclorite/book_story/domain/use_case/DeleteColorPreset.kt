package ua.acclorite.book_story.domain.use_case

import ua.acclorite.book_story.domain.model.ColorPreset
import ua.acclorite.book_story.domain.repository.BookRepository
import javax.inject.Inject

class DeleteColorPreset @Inject constructor(private val repository: BookRepository) {

    suspend fun execute(colorPreset: ColorPreset) {
        repository.deleteColorPreset(colorPreset)
    }
}