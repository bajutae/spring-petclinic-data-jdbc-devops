package org.springframework.samples.petclinic.model;

import java.util.Locale;
import java.util.Set;

import javax.validation.ConstraintViolation;
import javax.validation.Validator;

import org.junit.jupiter.api.Test;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.samples.petclinic.owner.Owner;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * @author Michael Isvy Simple test to make sure that Bean Validation is working (useful
 * when upgrading to a new version of Hibernate Validator/ Bean Validation)
 */
public class ValidatorTests {

    private Validator createValidator() {
        LocalValidatorFactoryBean localValidatorFactoryBean = new LocalValidatorFactoryBean();
        localValidatorFactoryBean.afterPropertiesSet();
        return localValidatorFactoryBean;
    }

    @Test
    public void shouldNotValidateWhenFirstNameEmpty() {

        LocaleContextHolder.setLocale(Locale.ENGLISH);
        Owner person = new Owner();
        person.setFirstName("");
        person.setLastName("smith");
        person.setAddress("some address");
        person.setCity("some city");
        person.setTelephone("9998882221");

        Validator validator = createValidator();
        Set<ConstraintViolation<Owner>> constraintViolations = validator
                .validate(person);

        assertThat(constraintViolations.size()).isEqualTo(1);
        ConstraintViolation<Owner> violation = constraintViolations.iterator().next();
        assertThat(violation.getPropertyPath().toString()).isEqualTo("firstName");
        assertThat(violation.getMessage()).isEqualTo("must not be empty");
    }

}
