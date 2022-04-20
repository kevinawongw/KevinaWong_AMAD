import android.app.Application
import androidx.lifecycle.*
import com.example.classes.data.Course
import com.example.classes.roomUtil.CourseDatabase
import com.example.classes.roomUtil.CourseRepository
import kotlinx.coroutines.launch

class CourseViewModel( application: Application): AndroidViewModel(application) {

    private val context = application.applicationContext
    private val courseDatabase = CourseDatabase.getDatabase(context)
    private val courseRepository = CourseRepository(courseDatabase.courseDao())
    val courseList: LiveData<List<Course>> = courseRepository.courseList

    fun add(course: Course) = viewModelScope.launch{
        courseRepository.insertItem(course)
    }

    fun delete(course: Course) = viewModelScope.launch{
        courseRepository.deleteItem(course)
    }

    fun deleteAll() = viewModelScope.launch{
        courseRepository.deleteAll()
    }
}