//package com.lt.detail;
//
//
//import org.junit.Test;
//import org.junit.runner.RunWith;
//import org.springframework.amqp.rabbit.core.RabbitTemplate;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.boot.test.context.SpringBootTest;
//import org.springframework.test.context.junit4.SpringRunner;
//
//@RunWith(SpringRunner.class)
//@SpringBootTest
//public class SpringAmqpTest {
//
//    @Autowired
//    private RabbitTemplate rabbitTemplate;
//
//    @Test
//    public void testSendMessageToSimpleQueue(){
//        String queueName = "simple.queue";
//        String message = "hhhhhhhhhhhhh";
//        rabbitTemplate.convertAndSend(queueName, message);
//    }
//
//}
