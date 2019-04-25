//package org.blockchain.rell.tests;
//
//import org.eclipse.xtext.testing.IInjectorProvider;
//import org.eclipse.xtext.testing.IRegistryConfigurator;
//import org.eclipse.xtext.testing.XtextRunner;
//import org.junit.runners.model.FrameworkMethod;
//import org.junit.runners.model.InitializationError;
//import org.junit.runners.model.Statement;
//import org.junit.runners.parameterized.BlockJUnit4ClassRunnerWithParameters;
//import org.junit.runners.parameterized.TestWithParameters;
//
//import com.google.inject.Injector;
//
//public class XtextRunnerWithParameters extends BlockJUnit4ClassRunnerWithParameters {
//
//    public class MyXtextRunner extends XtextRunner {
//
//        public MyXtextRunner(TestWithParameters test) throws InitializationError {
//            super(test.getTestClass().getJavaClass());
//        }
//
//        public IInjectorProvider getOrCreateInjectorProvider() {
//            return super.getOrCreateInjectorProvider();
//        }
//    }
//
//    private MyXtextRunner xtextRunner;
//
//    public XtextRunnerWithParameters(TestWithParameters test) throws InitializationError {
//        super(test);
//        xtextRunner = new MyXtextRunner(test);
//    }
//
//    @Override
//    public Object createTest() throws Exception {
//        Object object = super.createTest();
//        IInjectorProvider injectorProvider = xtextRunner.getOrCreateInjectorProvider();
//        if (injectorProvider != null) {
//            Injector injector = injectorProvider.getInjector();
//            if (injector != null)
//                injector.injectMembers(object);
//        }
//        return object;
//    }
//
//    @Override
//    protected Statement methodBlock(FrameworkMethod method) {
//        IInjectorProvider injectorProvider = xtextRunner.getOrCreateInjectorProvider();
//        if (injectorProvider instanceof IRegistryConfigurator) {
//            final IRegistryConfigurator registryConfigurator = (IRegistryConfigurator) injectorProvider;
//            registryConfigurator.setupRegistry();
//            final Statement methodBlock = superMethodBlock(method);
//            return new Statement() {
//                @Override
//                public void evaluate() throws Throwable {
//                    try {
//                        methodBlock.evaluate();
//                    } finally {
//                        registryConfigurator.restoreRegistry();
//                    }
//                }
//            };
//        } else {
//            return superMethodBlock(method);
//        }
//    }
//
//    protected Statement superMethodBlock(FrameworkMethod method) {
//        return super.methodBlock(method);
//    }
//
//}