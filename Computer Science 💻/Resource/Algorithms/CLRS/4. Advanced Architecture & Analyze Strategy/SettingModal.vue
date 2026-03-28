<script setup lang="ts">
import { ref } from 'vue';
import InputLayout from '@/common/layout/slot/InputLayout.vue';
import { Validator } from "@/public/type/local/Validator";
import { InputslotProps } from '@/common/type/InputslotProps';
import ConfirmCancelButton from '@/common/component/ConfirmCancelButton.vue';
import { useShake } from '@/composable/useShake';
const { isVibration, triggerShake } = useShake();
import { onClickOutside } from '@vueuse/core';

const props = withDefaults(defineProps<{
  show: boolean;
  flag?: boolean;
  placeholder: string;
  validator: Validator;
  type: string;
}>(), {
  flag: true
})

const emits = defineEmits<{
  close: []
  ok: [value: string]
}>()

const onClose = () => {
  emits("close");
}

const target = ref<HTMLElement | null>(null);
onClickOutside(target, () => {
  onClose();
})
const val = ref('');

const onOk = () => {
  const err = props.validator.validateVal(val.value);
  if (err) {
    emits("ok", val.value);
  } else {
    triggerShake();
  }
  val.value = ''
}

</script>

<template>
  <Transition name="modal">
    <div v-if="show" class="modal">
      <div ref="target" :class="{ 'vibration': isVibration }" class="modal__container">
        <div class="modal__header">
          <slot name="header">default header</slot>
        </div>

        <div class="modal__body">
          <slot name="body"></slot>
          <input-layout v-model:="val" :placeholder="props.placeholder" :type="InputslotProps.text"
            :validator="props.validator" @keyup.enter="onOk()"></input-layout>
        </div>

        <div class="modal__hr">
          <hr>
        </div>

        <div class="modal__footer">
          <slot name="footer">
            <confirm-cancel-button @ok="onOk" @close="onClose"></confirm-cancel-button>
          </slot>
        </div>

      </div>
    </div>
  </Transition>
</template>

<style scoped lang="scss">
@use "@/common/asset/css/global" as *;

.modal {
  position: fixed;
  z-index: 9998;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  transition: opacity 0.3s ease;
  overflow-y: auto;
}

.modal__container {
  width: 500px;
  margin: auto;
  padding: 20px;
  background-color: #fff;
  border-radius: 15px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.33);
  transition: all 0.3s ease;
}

.modal__header {
  text-align: left;
  margin-top: 0;
  font-weight: bold;
  font-size: large;
}

.modal__body {
  text-align: center;
  margin: 20px 0;
}


.modal__hr hr {
  border: none; // 기본 테두리 제거
  border-top: 1px solid $black; // 원하는 색과 두께 지정
  margin: 0; // 필요에 따라 여백 조정
}


.modal-default-button {
  height: 45px;
  width: 100%;
  border: none;
  background-color: transparent;
  border-radius: 15px;
}

.modal-default-button:hover {
  cursor: pointer;
  background-color: #666666;
}


/*
 * The following styles are auto-applied to elements with
 * transition="modal" when their visibility is toggled
 * by Vue.js.
 *
 * You can easily play with the modal transition by editing
 * these styles.
 */

.modal-enter-from {
  opacity: 0;
}

.modal-leave-to {
  opacity: 0;
}

.modal-enter-from .modal__container,
.modal-leave-to .modal__container {
  -webkit-transform: scale(1.1);
  transform: scale(1.1);
}

.vibration {
  animation: vibration 0.1s infinite;
  /* 빠르게 무한 반복 */
}

/* 잘못된 걸 눌렀을 때 진동효과 */
@keyframes vibration {

  0%,
  100% {
    transform: translateX(0);
  }

  20% {
    transform: translateX(-2px);
  }

  40% {
    transform: translateX(2px);
  }

  60% {
    transform: translateX(-2px);
  }

  80% {
    transform: translateX(2px);
  }
}
</style>