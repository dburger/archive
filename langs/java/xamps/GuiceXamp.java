package com.dburger.guice.xamp;

import com.google.inject.AbstractModule;
import com.google.inject.Guice;
import com.google.inject.Inject;
import com.google.inject.Injector;
import com.google.inject.Provider;
import com.google.inject.Provides;

import com.google.inject.name.Named;
import com.google.inject.name.Names;

public class GuiceXamp {

    public static interface LinkedBinding {

        void linkedBinding();

    }

    public static interface InstanceBinding {

        void instanceBinding();

    }


    public static interface ProviderMethodBinding {

        void providerMethodBinding();

    }

    public static interface ProviderBinding {

        void providerBinding();

    }

    public static class LinkedBindingImpl implements LinkedBinding {

        public LinkedBindingImpl() {}

        public void linkedBinding() {
            System.out.println("i come from linked binding");
        }

    }

    public static class InstanceBindingImpl implements InstanceBinding {

        public void instanceBinding() {
            System.out.println("i come from instance binding");
        }

    }

    public static class ProviderBindingProvider
            implements Provider<ProviderBinding> {

        public ProviderBinding get() {
            return new ProviderBinding() {
                public void providerBinding() {
                    System.out.println("i come from a provider binding");
                }
            };
        }
    }

    public static class WorldDominationModule extends AbstractModule {

        @Override
        public void configure() {
            // 1. "linked" binding
            bind(LinkedBinding.class).to(LinkedBindingImpl.class);
            // 2. "instance" binding -- with an annotation
            bind(String.class).annotatedWith(Names.named("JDBC URL"))
                    .toInstance("jdbc:mysql://localhost/whatever");
            // you cannot be serious
            bind(InstanceBinding.class)
                    .toInstance((InstanceBinding)new InstanceBindingImpl());
            // 4. Provider bindings
            bind(ProviderBinding.class)
                    .toProvider(ProviderBindingProvider.class);
            // 5. no JIT examples

            // 6. method injection parameter
            bind(String.class).annotatedWith(Names.named("method injection"))
                    .toInstance("i was method injected");

            // 7. field injection
            bind(String.class).annotatedWith(Names.named("field injection"))
                    .toInstance("i was field injected");
        }

        // 3. @Provides method binding
        @Provides
        public ProviderMethodBinding provideProviderMethodBinding() {
            return new ProviderMethodBinding() {
                public void providerMethodBinding() {
                    System.out.println("i come from a provider method binding");
                }
            };
        }

    }

    public static class WorldDominator {

        private LinkedBinding linkedBinding;
        private InstanceBinding instanceBinding;
        private String connUrl;
        private ProviderBinding providerBinding;
        private ProviderMethodBinding providerMethodBinding;

        private String methodInjection;

        @Inject @Named("field injection")
        private String fieldInjection;

        @Inject
        public WorldDominator(LinkedBinding linkedBinding,
                InstanceBinding instanceBinding,
                @Named("JDBC URL") String connUrl,
                ProviderMethodBinding providerMethodBinding,
                ProviderBinding providerBinding) {
            this.linkedBinding = linkedBinding;
            this.instanceBinding = instanceBinding;
            this.connUrl = connUrl;
            this.providerMethodBinding = providerMethodBinding;
            this.providerBinding = providerBinding;
        }

        @Inject
        public void setMethodInjection(@Named("method injection") String methodInjection) {
            this.methodInjection = methodInjection;
        }

        public void dominate() {
            this.linkedBinding.linkedBinding();
            this.instanceBinding.instanceBinding();
            System.out.println("the connUrl turned out to be: " + this.connUrl);
            this.providerMethodBinding.providerMethodBinding();
            this.providerBinding.providerBinding();
            System.out.println(this.methodInjection);
            System.out.println(this.fieldInjection);
        }

    }

    public static void main(String[] args) {
        System.out.println("hello world, going to inject...");
        System.out.println("=================================================");
        Injector injector = Guice.createInjector(new WorldDominationModule());
        WorldDominator wd = injector.getInstance(WorldDominator.class);
        wd.dominate();
        System.out.println("=================================================");
    }

}
