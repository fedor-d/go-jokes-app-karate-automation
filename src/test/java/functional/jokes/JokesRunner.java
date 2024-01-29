package functional.jokes;

import com.intuit.karate.junit5.Karate;

class JokesRunner {

    @Karate.Test
    Karate testUsers() {
        return Karate.run("jokes").relativeTo(getClass());
    }

}
